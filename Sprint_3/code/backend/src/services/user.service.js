//contributer: Piyawat Sawatkul [Description] มีเงื่อนไขว่ารหัสผ่านใหม่ต้องไม่ซ้ำกับ 5 รหัสผ่านล่าสุด และต้องไม่เหมือนกับรหัสปัจจุบัน โดยเก็ยบประวัติรหัสผ่านในตาราง PasswordHistory และตรวจสอบเมื่อมีการเปลี่ยนรหัสผ่าน
//และให้รหัสผ่านมีอายุการใช้งาน 90 วัน หลังจากนั้นจะหมดอายุและต้องเปลี่ยนรหัสผ่านใหม่
// Ai declare : ให้ chatgpt ช่วยอธิบายหลักการของโค้ดโดยรวมและช่วยไกด์การเขียนโค้ด
const prisma = require("../utils/prisma");
const ApiError = require('../utils/ApiError');
const bcrypt = require("bcrypt");
const { getPasswordUserInfoToken } = require("../validations/passwordValidator");
const SALT_ROUNDS = 10;
const PASSWORD_HISTORY_LIMIT = 5;
const PASSWORD_EXPIRES_DAYS = 90;

const searchUsers = async (opts = {}) => {
    const {
        page = 1,
        limit = 20,
        q,
        role,
        isActive,
        isVerified,
        createdFrom,
        createdTo,
        sortBy = 'createdAt',
        sortOrder = 'desc',
    } = opts;

    const where = {
        ...(role && { role }),
        ...(typeof isActive === 'boolean' ? { isActive } : {}),
        ...(typeof isVerified === 'boolean' ? { isVerified } : {}),
        ...((createdFrom || createdTo) ? {
            createdAt: {
                ...(createdFrom ? { gte: new Date(createdFrom) } : {}),
                ...(createdTo ? { lte: new Date(createdTo) } : {}),
            }
        } : {}),
        ...(q ? {
            OR: [
                { email: { contains: q, mode: 'insensitive' } },
                { username: { contains: q, mode: 'insensitive' } },
                { firstName: { contains: q, mode: 'insensitive' } },
                { lastName: { contains: q, mode: 'insensitive' } },
                { phoneNumber: { contains: q, mode: 'insensitive' } },
            ]
        } : {}),
    };

    const skip = (page - 1) * limit;
    const take = limit;

    const [total, dataRaw] = await prisma.$transaction([
        prisma.user.count({ where }),
        prisma.user.findMany({
            where,
            orderBy: { [sortBy]: sortOrder },
            skip, take,
            select: {
                id: true, email: true, username: true,
                firstName: true, lastName: true, gender: true,
                phoneNumber: true, profilePicture: true,
                role: true, isVerified: true, isActive: true,
                createdAt: true, updatedAt: true,
            }
        })
    ]);

    return {
        data: dataRaw,
        pagination: {
            page,
            limit,
            total,
            totalPages: Math.ceil(total / limit),
        }
    };
};

const getUserByEmail = async (email) => {
    return await prisma.user.findUnique({ where: { email } })
}

const getUserByUsername = async (username) => {
    return await prisma.user.findUnique({ where: { username } })
}

const comparePassword = async (user, plainPassword) => {
    return bcrypt.compare(plainPassword, user.password);
};

const getAllUsers = async () => {
    const users = await prisma.user.findMany({
        where: {
            isActive: true
        }
    })

    // หรือจะสร้าง object ใหม่แบบนี้ก็ได้ (ปลอดภัยกว่า)
    /*
    const safeUsers = users.map(user => ({
      id: user.id,
      email: user.email,
      username: user.username,
      // ... เอาฟิลด์อื่นๆ ที่ต้องการมาใส่ ...
    }));
    */

    return users.map(user => {
        const { password, ...safeUser } = user;
        return safeUser;
    });
}

const getUserById = async (id) => {
    const user = await prisma.user.findUnique({ where: { id } })

    if (!user) {
        throw new ApiError(404, 'User not found');
    }

    const { password, ...safeUser } = user;
    return safeUser
}

const getUserPublicById = async (id) => {
    const user = await prisma.user.findUnique({
        where: { id },
        select: {
            id: true, firstName: true, lastName: true,
            profilePicture: true, role: true, isVerified: true,
            createdAt: true
        }
    });
    if (!user) throw new ApiError(404, 'User not found');
    return user;
};

// const getMyUser = async (id) => {
//     const user = await prisma.user.findUnique({ where: { id } })

//     if (!user) {
//         return null;
//     }

//     const { password, ...safeUser } = user;
//     return safeUser
// }

const createUser = async (data) => {
    const existingUserByEmail = await getUserByEmail(data.email);
    if (existingUserByEmail) {
        throw new ApiError(409, "This email is already in use.");
    }
    const existingUserByUsername = await getUserByUsername(data.username);
    if (existingUserByUsername) {
        throw new ApiError(409, "This username is already taken.");
    }
    const hashedPassword = await bcrypt.hash(data.password, SALT_ROUNDS);
    const { now, expiresAt } = getPasswordLifecycleDates();

    const createData = {
        email: data.email,
        username: data.username,
        password: hashedPassword,
        passwordChangedAt: now,
        passwordExpiresAt: expiresAt,
        firstName: data.firstName,
        lastName: data.lastName,
        phoneNumber: data.phoneNumber,
        gender: data.gender,
        nationalIdNumber: data.nationalIdNumber,
        nationalIdExpiryDate: new Date(data.nationalIdExpiryDate), // แปลง string เป็น Date object
        nationalIdPhotoUrl: data.nationalIdPhotoUrl, // URL จาก Cloudinary
        selfiePhotoUrl: data.selfiePhotoUrl, // URL จาก Cloudinary
        role: data.role || 'PASSENGER'
    };

    const user = await prisma.user.create({ data: createData });

    const { password, ...safeUser } = user;
    return safeUser;
}

const getUserWithPasswordState = async (userId) => {
    return prisma.user.findUnique({
        where: { id: userId },
        include: {
            oldPassword: {
                orderBy: { storedAt: 'desc' },
                take: PASSWORD_HISTORY_LIMIT,
            },
        },
    });
};

const getPasswordLifecycleDates = () => {
    const now = new Date();
    const expiresAt = new Date(now);
    expiresAt.setDate(expiresAt.getDate() + PASSWORD_EXPIRES_DAYS);

    return { now, expiresAt };
};

const getPasswordReuseError = async (userWithPassword, newPassword) => {
    const isSameAsCurrent = await bcrypt.compare(newPassword, userWithPassword.password);
    if (isSameAsCurrent) {
        return 'PASSWORD_UNCHANGED';
    }

    for (const history of userWithPassword.oldPassword) {
        const isReused = await bcrypt.compare(newPassword, history.passwordHash);
        if (isReused) {
            return 'PASSWORD_REUSED';
        }
    }

    return null;
};

const buildPasswordUpdatePayload = async (userId, newPassword) => {
    const userWithPassword = await getUserWithPasswordState(userId);

    if (!userWithPassword) {
        throw new ApiError(404, 'User not found');
    }

    const matchedToken = getPasswordUserInfoToken(newPassword, userWithPassword);
    if (matchedToken) {
        throw new ApiError(400, 'รหัสผ่านต้องไม่มีชื่อผู้ใช้ อีเมล ชื่อจริง หรือนามสกุล');
    }

    const reuseError = await getPasswordReuseError(userWithPassword, newPassword);
    if (reuseError === 'PASSWORD_UNCHANGED') {
        throw new ApiError(400, 'New password must not be the same as the current password');
    }
    if (reuseError === 'PASSWORD_REUSED') {
        throw new ApiError(400, 'รหัสผ่านใหม่ต้องไม่ซ้ำกับ 5 รหัสผ่านที่เคยใช้ล่าสุด');
    }

    const hashedNewPassword = await bcrypt.hash(newPassword, SALT_ROUNDS);
    const { now, expiresAt } = getPasswordLifecycleDates();

    return {
        userWithPassword,
        passwordData: {
            password: hashedNewPassword,
            passwordChangedAt: now,
            passwordExpiresAt: expiresAt,
        },
    };
};

const updatePassword = async (userId, currentPassword, newPassword) => {
    const userWithPassword = await getUserWithPasswordState(userId);

    if (!userWithPassword) {
        return { success: false, error: 'USER_NOT_FOUND' };
    }

    const isPasswordCorrect = await bcrypt.compare(currentPassword, userWithPassword.password);
    if (!isPasswordCorrect) {
        return { success: false, error: 'INCORRECT_PASSWORD' };
    }

    const reuseError = await getPasswordReuseError(userWithPassword, newPassword);
    if (reuseError) {
        return { success: false, error: reuseError };
    }

    const hashedNewPassword = await bcrypt.hash(newPassword, SALT_ROUNDS);
    const { now, expiresAt } = getPasswordLifecycleDates();

    await prisma.$transaction([
        // บันทึกรหัสเก่าลง PasswordHistory
        prisma.passwordHistory.create({
            data: { userId, passwordHash: userWithPassword.password },
        }),
        // อัปเดตรหัสใหม่ + เวลา
        prisma.user.update({
            where: { id: userId },
            data: {
                password: hashedNewPassword,
                passwordChangedAt: now,
                passwordExpiresAt: expiresAt,
            },
        }),
    ]);

    return { success: true };
};

const updateUserProfile = async (id, data) => {
    const { password: newPassword, ...restData } = data;

    let updatedUser;

    if (newPassword) {
        const { userWithPassword, passwordData } = await buildPasswordUpdatePayload(id, newPassword);

        updatedUser = await prisma.$transaction(async (tx) => {
            await tx.passwordHistory.create({
                data: { userId: id, passwordHash: userWithPassword.password },
            });

            return tx.user.update({
                where: { id },
                data: {
                    ...restData,
                    ...passwordData,
                },
            });
        });
    } else {
        updatedUser = await prisma.user.update({ where: { id }, data: restData });
    }

    const { password, ...safeUser } = updatedUser;
    return safeUser;
};

const deleteUser = async (id) => {
    const deletedUser = await prisma.user.delete({ where: { id } });

    const { password, ...safeDeletedUser } = deletedUser;
    return safeDeletedUser;
};

// const setUserStatusActive = async (id, isActive) => {
//     const updatedUser = await prisma.user.update({
//         where: { id },
//         data: { isActive: isActive },
//     });

//     const { password, ...safeUser } = updatedUser;
//     return safeUser;
// };

// const setUserStatusVerified = async (id, isVerified) => {
//     const updatedUser = await prisma.user.update({
//         where: { id },
//         data: { isVerified: isVerified },
//     });

//     const { password, ...safeUser } = updatedUser;
//     return safeUser;
// };

module.exports = {
    searchUsers,
    getAllUsers,
    getUserById,
    createUser,
    getUserByEmail,
    getUserByUsername,
    comparePassword,
    updatePassword,
    deleteUser,
    updateUserProfile,
    getUserPublicById,
};