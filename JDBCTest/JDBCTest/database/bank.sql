CREATE SCHEMA IF NOT EXISTS bank;

USE bank;

CREATE TABLE IF NOT EXISTS accounts (
	anumber 	BIGINT(12) UNSIGNED PRIMARY KEY NOT NULL,
    balance 	DECIMAL(12,2) UNSIGNED NOT NULL DEFAULT 0
) ENGINE = INNODB;


DROP FUNCTION IF EXISTS validAccountNumber;
DROP PROCEDURE IF EXISTS createAccount;
DROP FUNCTION IF EXISTS getBalance;
DROP PROCEDURE IF EXISTS transfer;
DROP PROCEDURE IF EXISTS withdraw;
DROP PROCEDURE IF EXISTS deposit;

DELIMITER %%

CREATE FUNCTION validAccountNumber (accountNumber BIGINT(12))
	RETURNS BOOLEAN
    DETERMINISTIC
BEGIN
	RETURN 
		accountNumber > 99999999999
        AND
        accountNumber < 999999999999
        AND
        MOD(ROUND(accountNumber / 100, 0), 97) = MOD(accountNumber, 100);
END %%

CREATE PROCEDURE createAccount(IN accountNumber BIGINT(12))
BEGIN
	IF (bank.validAccountNumber(accountNumber)) THEN
		INSERT INTO bank.accounts (anumber)
        VALUES(accountNumber);
    END IF;
END %%

CREATE FUNCTION getBalance(accountNumber BIGINT(12)) RETURNS DECIMAL(12,2) DETERMINISTIC
BEGIN
	DECLARE z DECIMAL(12,2);
    SELECT balance INTO z 
		FROM accounts 
        WHERE anumber = accountNumber 
        LIMIT 1;
    RETURN z;
END %%

CREATE PROCEDURE transfer(
	IN fromAccount BIGINT(12),
    IN toAccount   BIGINT(12),
    IN _amount     DECIMAL(12,2)
)
BEGIN
	UPDATE accounts f, accounts t
    SET f.amount = f.amount - _amount
	,	t.amount = t.amount + _amount
    WHERE getbalance(fromAccount) >= _amount
    AND   f.anumber = fromAccount
    AND	  t.anumber = toAccount
    ;
END %%

CREATE PROCEDURE deposit(
	IN toAccount   BIGINT(12),
    IN _amount     DECIMAL(12,2)
)
BEGIN
	UPDATE accounts
    SET amount = amount + _amount
    WHERE anumber = toAccount;
END %%

CREATE PROCEDURE withdraw(
	IN fromAccount   BIGINT(12),
    IN _amount     DECIMAL(12,2)
)
BEGIN
	UPDATE accounts
    SET amount = amount + _amount
    WHERE anumber = fromAccount;
END %%

DELIMITER ;





