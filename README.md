# Suggestion_app
## Introduction
This is a simple web application that allows users to enter the suggestion in the input field and the system will automatically suggest the word that the user is typing. The system will also show the location of the suggestion state on the map. The frontend is built using Vue.js and the backend is built using Go. The frontend will run on http://localhost:8080 and the backend will run on http://localhost:8081.

## Project setup
```
docker compose up -build
```
### Troubleshooting
* Make sure you have install _docker_ and _go_ and _npm_
```
docker compose up -build
```
* If the docker-compose up -build command doesn't work, you can run the following command:
```
cd suggestion_app
npm run serve
```
* Then, go back to the root directory and run the following command:
```
cd backend
go run main.go
```
* The frontend will run on http://localhost:8080 and the backend will run on http://localhost:8081
* Not sure why the docker-compose up -build command doesn't work, but the above command should work.

## Demo
* User can enter the suggestion in the input field and the system will automatically suggest the word that the user is typing.
![alt text](/img/image.png)
* There's dropdown list that shows the suggestion states.
![alt text](/img/image-1.png)
![alt text](/img/image2.png)
![alt text](/img/image3.png)
* After user click the suggestion state, the map will show the location of the suggestion state.
![alt text](/img/image4.png)

