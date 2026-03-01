/*
  Warnings:

  - A unique constraint covering the columns `[booking_id,user_id]` on the table `Reviews` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "Reviews_booking_id_user_id_key" ON "Reviews"("booking_id", "user_id");
