USE `mcmmo`;
SET @id=0;
SELECT @id := @id +1 AS id,t1.`user`,t2.`swords` AS level
FROM `mcmmo_users` AS t1
INNER JOIN `mcmmo_skills` AS t2
WHERE t2.`swords`>0
AND t1.`id`=t2.`user_id`
ORDER BY t2.`swords` DESC
LIMIT 10
