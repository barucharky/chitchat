package data

type Most struct {
	UserName string
	NumPosts int
}

// Get all users in the database and returns it
func Mosts() (mosts []Most, err error) {

	sqlQuery := `
	SELECT   u.name username, count(*) numposts
	FROM     users u
		LEFT JOIN posts p
		  ON u.id = p.user_id
	GROUP BY u.name
	ORDER BY 2 DESC;`

	rows, err := Db.Query(sqlQuery)
	if err != nil {
		return
	}
	for rows.Next() {
		conv := Most{}
		if err = rows.Scan(&conv.UserName, &conv.NumPosts); err != nil {
			return
		}
		mosts = append(mosts, conv)
	}
	rows.Close()
	return
}
