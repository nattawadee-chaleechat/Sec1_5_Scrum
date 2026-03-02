/*
  Warnings:

  - You are about to drop the column `Star` on the `Review` table. All the data in the column will be lost.
  - You are about to drop the column `picture` on the `Review` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[bookingId,reviewerId]` on the table `Review` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `updatedAt` to the `Booking` table without a default value. This is not possible if the table is not empty.
  - Added the required column `star` to the `Review` table without a default value. This is not possible if the table is not empty.

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

-- AlterTable
ALTER TABLE "Review" DROP COLUMN "Star",
DROP COLUMN "picture",
ADD COLUMN     "media" JSON,
ADD COLUMN     "star" INTEGER NOT NULL;

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
CREATE INDEX "RouteExtraCharge_routeId_idx" ON "RouteExtraCharge"("routeId");

-- CreateIndex
CREATE UNIQUE INDEX "RouteExtraCharge_routeId_name_key" ON "RouteExtraCharge"("routeId", "name");

-- CreateIndex
CREATE INDEX "BookingExtraCharge_bookingId_idx" ON "BookingExtraCharge"("bookingId");

-- CreateIndex
CREATE INDEX "BookingExtraCharge_routeExtraChargeId_idx" ON "BookingExtraCharge"("routeExtraChargeId");

-- CreateIndex
CREATE UNIQUE INDEX "BookingExtraCharge_bookingId_routeExtraChargeId_key" ON "BookingExtraCharge"("bookingId", "routeExtraChargeId");

-- CreateIndex
CREATE INDEX "Review_bookingId_idx" ON "Review"("bookingId");

-- CreateIndex
CREATE UNIQUE INDEX "Review_bookingId_reviewerId_key" ON "Review"("bookingId", "reviewerId");

-- AddForeignKey
ALTER TABLE "RouteExtraCharge" ADD CONSTRAINT "RouteExtraCharge_routeId_fkey" FOREIGN KEY ("routeId") REFERENCES "Route"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BookingExtraCharge" ADD CONSTRAINT "BookingExtraCharge_bookingId_fkey" FOREIGN KEY ("bookingId") REFERENCES "Booking"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BookingExtraCharge" ADD CONSTRAINT "BookingExtraCharge_routeExtraChargeId_fkey" FOREIGN KEY ("routeExtraChargeId") REFERENCES "RouteExtraCharge"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
