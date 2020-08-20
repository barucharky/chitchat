# B"H


## Follow `http://b7forum.com/` using an incognito window:

---

### STEP 1: `main` (in `main.go`)

    ```go
    mux.HandleFunc("/", index)
    ```

    See details below:



---

### STEP 2: `mux.HandleFunc("/", index)`
- `route_main.go`
- `package main`

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

Return slice of Thread structs.




---

### STEP 4: Now jump back to next line in `index` function in STEP 2.

```go
generateHTML(writer, threads, "layout", "public.navbar", "index")
```





---

### STEP 5: `generateHTML ...`
- `utils.go`
- `package main`