-- AlterTable
ALTER TABLE "Booking" ALTER COLUMN "baseTotalPrice" SET DEFAULT 0,
ALTER COLUMN "extraTotalPrice" SET DEFAULT 0,
ALTER COLUMN "totalPrice" SET DEFAULT 0;

-- AlterTable
ALTER TABLE "BookingExtraCharge" ALTER COLUMN "totalExtraPrice" SET DEFAULT 0;
