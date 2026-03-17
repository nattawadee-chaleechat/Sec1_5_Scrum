/*
  Warnings:

  - Added the required column `updatedAt` to the `Booking` table without a default value. This is not possible if the table is not empty.

*/
-- AlterEnum
ALTER TYPE "BookingStatus" ADD VALUE 'COMPLETED';

-- AlterEnum
ALTER TYPE "NotificationType" ADD VALUE 'REVIEW';

-- AlterTable
ALTER TABLE "Booking" ADD COLUMN     "baseTotalPrice" DOUBLE PRECISION NOT NULL DEFAULT 0,
ADD COLUMN     "completedAt" TIMESTAMP(3),
ADD COLUMN     "driver_confirm_arrived" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "extraTotalPrice" DOUBLE PRECISION NOT NULL DEFAULT 0,
ADD COLUMN     "passenger_confirm_arrived" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "totalPrice" DOUBLE PRECISION NOT NULL DEFAULT 0,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL;

-- CreateTable
CREATE TABLE "Review" (
    "id" TEXT NOT NULL,
    "star" INTEGER NOT NULL,
    "comment" TEXT,
    "media" JSON,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "bookingId" TEXT NOT NULL,
    "reviewerId" TEXT NOT NULL,
    "reviewedUserId" TEXT NOT NULL,

    CONSTRAINT "Review_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RouteExtraCharge" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "unitPrice" DOUBLE PRECISION NOT NULL,
    "routeId" TEXT NOT NULL,

    CONSTRAINT "RouteExtraCharge_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BookingExtraCharge" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,
    "unitPrice" DOUBLE PRECISION NOT NULL,
    "totalExtraPrice" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "bookingId" TEXT NOT NULL,
    "routeExtraChargeId" TEXT NOT NULL,

    CONSTRAINT "BookingExtraCharge_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "Review_bookingId_idx" ON "Review"("bookingId");

-- CreateIndex
CREATE INDEX "Review_reviewedUserId_idx" ON "Review"("reviewedUserId");

-- CreateIndex
CREATE INDEX "Review_reviewerId_idx" ON "Review"("reviewerId");

-- CreateIndex
CREATE UNIQUE INDEX "Review_bookingId_reviewerId_key" ON "Review"("bookingId", "reviewerId");

-- CreateIndex
CREATE INDEX "RouteExtraCharge_routeId_idx" ON "RouteExtraCharge"("routeId");

-- CreateIndex
CREATE UNIQUE INDEX "RouteExtraCharge_routeId_name_key" ON "RouteExtraCharge"("routeId", "name");

-- CreateIndex
CREATE INDEX "BookingExtraCharge_bookingId_idx" ON "BookingExtraCharge"("bookingId");

-- CreateIndex
CREATE INDEX "BookingExtraCharge_routeExtraChargeId_idx" ON "BookingExtraCharge"("routeExtraChargeId");

-- CreateIndex
CREATE UNIQUE INDEX "BookingExtraCharge_bookingId_routeExtraChargeId_key" ON "BookingExtraCharge"("bookingId", "routeExtraChargeId");

-- AddForeignKey
ALTER TABLE "Review" ADD CONSTRAINT "Review_bookingId_fkey" FOREIGN KEY ("bookingId") REFERENCES "Booking"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Review" ADD CONSTRAINT "Review_reviewerId_fkey" FOREIGN KEY ("reviewerId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Review" ADD CONSTRAINT "Review_reviewedUserId_fkey" FOREIGN KEY ("reviewedUserId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RouteExtraCharge" ADD CONSTRAINT "RouteExtraCharge_routeId_fkey" FOREIGN KEY ("routeId") REFERENCES "Route"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BookingExtraCharge" ADD CONSTRAINT "BookingExtraCharge_bookingId_fkey" FOREIGN KEY ("bookingId") REFERENCES "Booking"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BookingExtraCharge" ADD CONSTRAINT "BookingExtraCharge_routeExtraChargeId_fkey" FOREIGN KEY ("routeExtraChargeId") REFERENCES "RouteExtraCharge"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
