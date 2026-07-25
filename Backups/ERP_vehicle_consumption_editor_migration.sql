ALTER TABLE `vehicles`
ADD COLUMN IF NOT EXISTS `fuel_consumption_rate` FLOAT NOT NULL DEFAULT 1.0 AFTER `mileage`;

INSERT INTO `servercore` (`keyname`, `value`) VALUES
('DefaultVehicleFuelConsumption', '1.0')
ON DUPLICATE KEY UPDATE `value` = `value`;
