# B"H


## Follow `http://b7forum.com/` after logging in first:

---

### STEP 1: `main` (in `main.go`)

```go
mux.HandleFunc("/", index)
```

Here's the full index function:

```go
func index(writer http.ResponseWriter, request *http.Request) {

	threads, err := data.Threads()

	if err != nil {
		error_message(writer, request, "Cannot get threads")
	} else {
		_, err := session(writer, request)

		if err != nil {
			generateHTML(writer, threads, "layout", "public.navbar", "index")
		} else {
			generateHTML(writer, threads, "layout", "private.navbar", "index")
		}

	}
}
```


    See details below:


---

### STEP 2: `mux.HandleFunc("/", index)`
FILE: `route_main.go`
- Note we're still in `package main`

```go

func index(writer http.ResponseWriter, request *http.Request) {

	threads, err := data.Threads()

    ...
    ...
    
}

```




---

### STEP 3: `threads, err := data.Threads()`
- `data/thread.go`
- `package data`
- Get all threads in the database and returns it

Runs this query:

```sql
select   id, uuid, topic, user_id, created_at 
from     threads 
order by created_at desc
;
```

Return slice of Thread structs `threads []Thread`




---

### STEP 4: Now jump back to next line in `index` function in STEP 2.

```go
_, err := session(writer, request)
```

... here's the code.

1. Get the cookie from the request that came in from the client.

2. Create a session struct and add the cookie value form the client: `sess = data.Session{Uuid: cookie.Value}`

3. Check if the cookie is valid: `sess.Check()` 
    - Check STEP 5 then jump back

4. Check STEP 6     

```go

// Checks if the user is logged in and has a session, if not err is not nil
func session(writer http.ResponseWriter, request *http.Request) (sess data.Session, err error) {

	cookie, err := request.Cookie("_cookie")

	if err == nil {

		sess = data.Session{
            Uuid: cookie.Value,
        }

		if ok, _ := sess.Check(); !ok {
			err = errors.New("Invalid session")
		}
    }
    
	return
}
```


### STEP 5: 
- Query and put results in the session struct based on the UUID from the client's cookie
- If session appears to be valid set `valid = true`
- Jump back to STEP 4

```go

// Check (method) goes ahead and sees if the session is valid in the database
func (session *Session) Check() (valid bool, err error) {

	// Setup SQL query:
	stmt := `
		select   id, 
				 uuid, 
				 email, 
				 user_id, 
				 created_at 
	    from     sessions 
	    where    uuid = $1
	`

	// Run query and put results in the session struct
	err = Db.QueryRow(
		stmt,
		session.Uuid,
	).
		Scan(
			&session.Id,
			&session.Uuid,
			&session.Email,
			&session.UserId,
			&session.CreatedAt,
		)

	if err != nil {
		valid = false
		return
	}

	if session.Id != 0 {
		valid = true
	}

	return
}
```


---

### STEP 6: Now jump back to next line in `index` function:
- Generate the HTML
- In this case, being that session is valid (no err), we can use the private HTML templates.

```go
		if err != nil {
			generateHTML(writer, threads, "layout", "public.navbar", "index")
		} else {
			generateHTML(writer, threads, "layout", "private.navbar", "index")
		}
```





---

### STEP 7: `generateHTML ...`
- `utils.go`
- `package main`
- Notice how the function takes in a `writer`, data (in our case a slice of Threads), and a variadic parameter list of filenames.


```go
func generateHTML(writer http.ResponseWriter, data interface{}, filenames ...string) {

	var files []string

	for _, file := range filenames {
		files = append(files, fmt.Sprintf("templates/%s.html", file))
	}

	templates := template.Must(template.ParseFiles(files...))
	templates.ExecuteTemplate(writer, "layout", data)
}
```