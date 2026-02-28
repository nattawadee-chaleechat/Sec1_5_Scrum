-- AlterEnum
ALTER TYPE "BookingStatus" ADD VALUE 'COMPLETE';

-- AlterTable
ALTER TABLE "Booking" ADD COLUMN     "driver_comfirm_arrived" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "passenger_comfirm_arrived" BOOLEAN NOT NULL DEFAULT false;

-- CreateTable
CREATE TABLE "Reviews" (
    "id" TEXT NOT NULL,
    "star" INTEGER NOT NULL,
    "comment" TEXT,
    "picture" JSON,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "booking_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,

    CONSTRAINT "Reviews_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "Reviews_booking_id_idx" ON "Reviews"("booking_id");

-- CreateIndex
CREATE INDEX "Reviews_user_id_idx" ON "Reviews"("user_id");

-- AddForeignKey
ALTER TABLE "Reviews" ADD CONSTRAINT "Reviews_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reviews" ADD CONSTRAINT "Reviews_booking_id_fkey" FOREIGN KEY ("booking_id") REFERENCES "Booking"("id") ON DELETE CASCADE ON UPDATE CASCADE;
