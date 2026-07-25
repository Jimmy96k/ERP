-- ExpressRP matrun/point phase 2 migration
ALTER TABLE `job_matruns`
    ADD COLUMN IF NOT EXISTS `pickup_icon` int(11) NOT NULL DEFAULT 1271,
    ADD COLUMN IF NOT EXISTS `dropoff_icon` int(11) NOT NULL DEFAULT 1239,
    ADD COLUMN IF NOT EXISTS `pickup_name` varchar(64) NOT NULL DEFAULT 'Material Pickup',
    ADD COLUMN IF NOT EXISTS `dropoff_name` varchar(64) NOT NULL DEFAULT 'Material Factory',
    ADD COLUMN IF NOT EXISTS `pickup_point_id` int(11) NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS `dropoff_point_id` int(11) NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS `dropoff_point_cut_percent` int(11) NOT NULL DEFAULT 20;

UPDATE `job_matruns` SET `pickup_icon`=1271 WHERE `pickup_icon` IS NULL OR `pickup_icon` <= 0;
UPDATE `job_matruns` SET `dropoff_icon`=1239 WHERE `dropoff_icon` IS NULL OR `dropoff_icon` <= 0;

ALTER TABLE `points`
    ADD COLUMN IF NOT EXISTS `captured_by_name` varchar(64) NOT NULL DEFAULT '',
    ADD COLUMN IF NOT EXISTS `safe_balance` int(11) NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS `capture_time` int(11) NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS `expire_time` int(11) NOT NULL DEFAULT 0;
