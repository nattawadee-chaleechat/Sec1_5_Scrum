/*
  Warnings:

  - You are about to drop the column `driver_comfirm_arrived` on the `Booking` table. All the data in the column will be lost.
  - You are about to drop the column `passenger_comfirm_arrived` on the `Booking` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Booking" DROP COLUMN "driver_comfirm_arrived",
DROP COLUMN "passenger_comfirm_arrived",
ADD COLUMN     "driver_confirm_arrived" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "passenger_confirm_arrived" BOOLEAN NOT NULL DEFAULT false;
