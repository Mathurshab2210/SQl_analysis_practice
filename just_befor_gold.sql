CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `just_befor_gold` AS
    SELECT 
        `s`.`userid` AS `userid`,
        `s`.`product_id` AS `product_id`,
        `s`.`created_date` AS `created_date`,
        `g`.`gold_signup_date` AS `gold_signup_date`
    FROM
        (`sales` `s`
        JOIN `goldusers_signup` `g` ON (((`s`.`userid` = `g`.`userid`)
            AND (`s`.`created_date` <= `g`.`gold_signup_date`))))
