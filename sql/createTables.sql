CREATE TABLE IF NOT EXISTS User (
    -- UserID              INTEGER PRIMARY KEY AUTOINCREMENT,
    username            TEXT NOT NULL UNIQUE,
    -- FirstName           TEXT,
    -- LastName            TEXT,
    email               TEXT NOT NULL UNIQUE,
    password            TEXT NOT NULL,
    sessionToken        TEXT,
    sessionExpiration   DATETIME
);

CREATE TABLE IF NOT EXISTS Category (
    CategoryID      INTEGER PRIMARY KEY AUTOINCREMENT,
    CategoryName    TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Post (
    PostID          INTEGER PRIMARY KEY AUTOINCREMENT,
    Title           TEXT NOT NULL,
    Content         TEXT NOT NULL,
    CreatedDate     DATETIME DEFAULT CURRENT_TIMESTAMP,
    UserID          INTEGER,
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

CREATE TABLE IF NOT EXISTS Comment (
    CommentID       INTEGER PRIMARY KEY AUTOINCREMENT,
    Content         TEXT NOT NULL,
    CreatedDate     DATETIME DEFAULT CURRENT_TIMESTAMP,
    PostID          INTEGER,
    UserID          INTEGER,
    FOREIGN KEY (PostID) REFERENCES Post(PostID),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

CREATE TABLE IF NOT EXISTS PostCategory (
    PostCategoryID  INTEGER PRIMARY KEY AUTOINCREMENT,
    PostID          INTEGER,
    CategoryID      INTEGER,
    FOREIGN KEY (PostID) REFERENCES Post(PostID),
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);

CREATE TABLE IF NOT EXISTS Interaction (
    InteractionID   INTEGER PRIMARY KEY AUTOINCREMENT,
    PostID          INTEGER,
    UserID          INTEGER,
    Kind            INTEGER NOT NULL CHECK (Kind IN (0, 1)), -- 1 for like, 0 for dislike
    FOREIGN KEY (PostID) REFERENCES Post(PostID),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);
