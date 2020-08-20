# B"H


## Follow after clicking **Sign Up** button on `http://b7forum.com/signup`

---

### STEP 1: `http://b7forum.com/signup`

- Fill out the 3 fields
- Click the **SIGN UP** button




### STEP 2: 
- `templates/signup.html`
- Clicking the button calls the route `signup_account` and passes along the form data:
    1. name
    2. email
    3. password


```html
<form class="form-signin" role="form" action="/signup_account" method="post">
   

    <input id   = "name"    name = "name"      >
    <input                  name = "email"     >
    <input                  name = "password"  >

    
    <button type="submit">Sign up</button>

</form>
```



### STEP 3:
- `main.go`
- `mux.HandleFunc("/signup_account", signupAccount)`
- Remember all the above HTML form fields will be sent along to `/authenticate` and appear in Go within the `request *http.Request`


### STEP 4:

`/home/laz/repos/chitchat/route_auth.go`
1. Get the form data: `request.ParseForm()`
2. Populate `data.User` struct (3 of the fields) 
3. Create user: call `user.Create()` method. 
    - SEE NEXT STEP
4. After creating user redirect user to the `/login` page.

```go
// POST /signup
// Create the user account
func signupAccount(writer http.ResponseWriter, request *http.Request) {
    
    err := request.ParseForm()

	
	user := data.User{
		Name:     request.PostFormValue("name"),
		Email:    request.PostFormValue("email"),
		Password: request.PostFormValue("password"),
    }
    
	if err := user.Create(); err != nil {
		danger(err, "Cannot create user")
    }
    
	http.Redirect(writer, request, "/login", 302)
}
```


### STEP 5 - `user.Create()`
`data/user.go`
- For now ignore `UUID`
- Insert new user into `users` table
- Get back 3 more fields for the User struct; now the struct is completely populated except for pw.
- GO TO STEP 4.4


```go
// Create a new user, save user info into the database
func (user *User) Create() (err error) {

    statement := `
        insert into users 
               (
               uuid, 
               name, 
               email, 
               password, 
               created_at
               ) 
        values ($1, $2, $3, $4, $5) 
        returning id, uuid, created_at
    `

    stmt, err := Db.Prepare(statement)
    
	err = stmt.QueryRow(
        createUUID(), 
        user.Name, 
        user.Email, 
        Encrypt(user.Password), 
        time.Now()
    ).Scan(
        &user.Id, 
        &user.Uuid, 
        &user.CreatedAt
    )
    
    return
}
```