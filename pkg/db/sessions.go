package db

import (
	"database/sql"
	"log"
	"time"

	"github.com/google/uuid"
	"learn.reboot01.com/git/hbudalam/forum/pkg/structs"
)

func CreateSession(username string) (string, error) {
	token := uuid.New().String()
	expiry := time.Now().Add(24 * time.Hour)
	dbMutex.Lock()
	defer dbMutex.Unlock()
	_, err := db.Exec("UPDATE User SET sessionToken = ?, sessionExpiration = ? WHERE username = ?", token, expiry, username)
	if err != nil {
		return "", err
	}

	return token, nil
}

func GetSession(token string) (*structs.Session, error) {
	session := structs.Session{}

	dbMutex.Lock()
	defer dbMutex.Unlock()

	err := db.QueryRow("SELECT sessionToken, sessionExpiration, username FROM User WHERE sessionToken = ?", token).Scan(&session.Token, &session.Expiry, &session.User.Username)
	if err != nil {

		if err == sql.ErrNoRows {
			return nil, nil
		}
		log.Printf("GetSession: %s\n", err.Error())
		return nil, err
	}
	return &session, nil
}

func DeleteSession(token string) error {
	dbMutex.Lock()
	defer dbMutex.Unlock()
	_, err := db.Exec("UPDATE User SET sessionToken = NULL, sessionExpiration = NULL WHERE sessionToken = ?", token)
	return err
}

// func CheckActiveSession(username string) (bool, error) {
// 	var sessionExpiration time.Time
// 	err := db.QueryRow(`SELECT sessionExpiration FROM User WHERE username = ?`, username).Scan(&sessionExpiration)
// 	if err != nil {
// 		if err == sql.ErrNoRows {
// 			return false, nil
// 		}
// 		return false, err
// 	}

// 	return sessionExpiration.After(time.Now()), nil
// }

func CheckActiveSession(username string) (bool, error) {
	var sessionExpiration sql.NullTime
	err := db.QueryRow(`SELECT sessionExpiration FROM User WHERE username = ?`, username).Scan(&sessionExpiration)
	if err != nil {
		if err == sql.ErrNoRows {
			return false, nil
		}
		return false, err
	}

	if sessionExpiration.Valid {
		return sessionExpiration.Time.After(time.Now()), nil
	}
	return false, nil
}