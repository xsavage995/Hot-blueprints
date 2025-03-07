CREATE TABLE `hot_rewards` (
	`citizenId` VARCHAR(100) NOT NULL COLLATE 'utf8mb4_general_ci',
	`blueprints` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`citizenId`) USING BTREE
)
COLLATE='utf8mb3_general_ci'
ENGINE=InnoDB
;
