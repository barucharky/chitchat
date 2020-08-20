# B"H


## Follow `http://b7forum.com/` after logging in first:

---

### STEP 1: Click on the **Read more** link.
- It calls `/thread/read?id={{.Uuid }}`

```html
    <!-- ------------------------------ -->
    <!-- Note the below method calls (not struct fields) -->
    <div class="panel-body">
	  
	    Started by {{ .User.Name }} - {{ .CreatedAtDate }} - {{ .NumReplies }} posts.
		
		<div class="pull-right">
            <a href="/thread/read?id={{.Uuid }}">Read more</a>
	    </div>
	  
    </div>
```




### STEP 2: `mux.HandleFunc("/thread/read", readThread)`
FILE: `main.go`




### STEP 3: `readThread(writer http.ResponseWriter, request *http.Request)`
FILE: `route_thread.go`
PKG: `main`

1. Get the URL parameters and pull out the `uuid`:

```go
	// For example: `?id=d07956e4-0cdc-4064-4eae-3d05d4209932`
	vals := request.URL.Query()
	
	// For above example: `d07956e4-0cdc-4064-4eae-3d05d4209932`
	uuid := vals.Get("id")
```

2. Get the thread details from the DB:
    - `thread, err := data.ThreadByUUID(uuid)`
    - Go to STEP 4 then jump back. 

3. Generate the HTML
    - Look at STEP 5 for "private.thread" template	

```go
// GET /thread/read
// Show the details of the thread, including the posts and the form to write a post
func readThread(writer http.ResponseWriter, request *http.Request) {
	
	// For example: `?id=d07956e4-0cdc-4064-4eae-3d05d4209932`
	vals := request.URL.Query()
	
	// For above example: `d07956e4-0cdc-4064-4eae-3d05d4209932`
	uuid := vals.Get("id")
	

	thread, err := data.ThreadByUUID(uuid)
	
	if err != nil {
		error_message(writer, request, "Cannot read thread")
	} else {
		_, err := session(writer, request)
		if err != nil {
			generateHTML(writer, &thread, "layout", "public.navbar", "public.thread")
		} else {
			generateHTML(writer, &thread, "layout", "private.navbar", "private.thread")
		}
	}
}
```




### STEP 4: `data.ThreadByUUID(uuid)`
FILE: `thread.go`
PKG: `data`

- Get data from the DB for a single thread and return that.
- Jump back to STEP 3.

```go
// ThreadByUUID gets a thread by the UUID
func ThreadByUUID(uuid string) (conv Thread, err error) {

	conv = Thread{}

	stmt := `
		select   id, 
				 uuid, 
				 topic, 
				 user_id, 
				 created_at 
		from     threads 
		where    uuid = $1
	`

	err = Db.QueryRow(
		stmt,
		uuid,
	).
		Scan(
			&conv.Id,
			&conv.Uuid,
			&conv.Topic,
			&conv.UserId,
			&conv.CreatedAt,
		)

	return
}
```





### STEP 5: "private.thread" template


