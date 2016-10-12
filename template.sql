--// template sql script for shark-sync/tank
CREATE TABLE IF NOT EXISTS account (
    account_id          TEXT PRIMARY KEY,
    name                TEXT,
    balance             INTEGER,
    address             TEXT,
    admin_user          TEXT
);

-- used to lookup which accounts a user is attached to
CREATE TABLE IF NOT EXISTS account_user (
    user_id TEXT        PRIMARY KEY,
    account_id          TEXT
);
CREATE INDEX IF NOT EXISTS idx_account_user_account_id ON account_user(account_id);

-- used to validate user authentication
CREATE TABLE IF NOT EXISTS user (
    user_id             TEXT PRIMARY KEY,
    username            TEXT,
    passcode            TEXT,
    encryption_type     INTEGER
);
CREATE INDEX IF NOT EXISTS idx_user_username ON user(username);

-- account_transactions is for the storage of any node activity credits or debits.  Credits applied for any participation, and debits for any use of the APIs.  The transactions are grouped together by time, so aggregation can take place to update account balances with as little impact on the system as possible.

-- values for type would be an enum of things like participation credit, api usage, account credit.
CREATE TABLE IF NOT EXISTS account_transactions (
    trans_id            TEXT PRIMARY KEY,
    account_id          TEXT,
    trans_time          NUMBER,
    type                INTEGER,
    amount              INTEGER
);
CREATE INDEX IF NOT EXISTS idx_account_transactions_account_id_trans_time ON account_transactions(account_id, trans_time);

-- an application is pretty self explanatory.  Settings will be a dictionary of settings for the logic applied to that application.  E.g. record convergence mode (last in wins, latest wins, write once only).
CREATE TABLE IF NOT EXISTS application (
    app_id              TEXT PRIMARY KEY,
    app_api_access_key  TEXT,
    account_id          TEXT,
    app_settings        TEXT
);
CREATE INDEX IF NOT EXISTS idx_application_app_id_api_access_key ON application (app_id,app_api_access_key);
CREATE INDEX IF NOT EXISTS idx_application_account_id ON application (account_id);

-- the devices / unique installs
CREATE TABLE IF NOT EXISTS device (
    device_id           TEXT PRIMARY KEY,
    app_id              TEXT,
    account_id          TEXT,
    sync_id             TEXT,
    last_seen           NUMBER
);
CREATE INDEX IF NOT EXISTS idx_device_app_id ON device(app_id);
CREATE INDEX IF NOT EXISTS idx_device_account_id ON device(account_id);

CREATE TABLE IF NOT EXISTS change (
    change_id           TEXT PRIMARY KEY,
    rec_id              TEXT,
    path                TEXT,
    device_id           TEXT,
    modified            NUMBER,
    tidemark            NUMBER,
    value               TEXT
);
CREATE INDEX IF NOT EXISTS idx_change_tidemark ON change(tidemark);
CREATE INDEX IF NOT EXISTS idx_change_path ON change(path);
CREATE INDEX IF NOT EXISTS idx_rec_id ON change(rec_id, path, modified DESC);

--// trigger for evential consistency on change table
CREATE TRIGGER IF NOT EXISTS trigger_change_eventual_consistency
    AFTER INSERT
    ON change
BEGIN
    DELETE FROM change WHERE change_id IN (SELECT change_id FROM change WHERE rec_id = NEW.rec_id AND path = NEW.path ORDER BY modified DESC LIMIT 9999999 OFFSET 1);
END;
