# Kitaab

A simple **Journal REST API built with Spring Boot** for creating, retrieving, updating, and deleting journal entries.

Kitaab is a backend-focused project built to understand and implement the fundamentals of **Spring Boot, REST APIs, HTTP methods, request mapping, path variables, and in-memory data handling**.

## Features

* Create journal entries
* Retrieve all journal entries
* Retrieve a journal entry by ID
* Update existing journal entries
* Delete journal entries
* RESTful API architecture
* JSON-based request and response handling
* Path variable based API endpoints
* In-memory journal entry storage
* Postman collection for API testing

## Tech Stack

| Technology        | Usage                                |
| ----------------- | ------------------------------------ |
| Java 25           | Programming language                 |
| Spring Boot 4.1.1 | Backend framework                    |
| Spring Web MVC    | REST API development                 |
| Maven             | Dependency management and build tool |
| Postman           | API testing                          |

## Project Structure

```text
Kitaab/
├── .mvn/
│   └── wrapper/
│
├── .postman/
│
├── postman/
│   └── globals/
│
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── ...
│   │   └── resources/
│   │       └── ...
│   │
│   └── test/
│       └── ...
│
├── .gitattributes
├── .gitignore
├── mvnw
├── mvnw.cmd
├── pom.xml
└── README.md
```

## REST API

The application exposes REST endpoints for managing journal entries.

### Get All Entries

```http
GET /journal
```

Returns all available journal entries.

### Get Entry By ID

```http
GET /journal/id/{myId}
```

Returns the journal entry associated with the given ID.

Example:

```http
GET /journal/id/1
```

### Create Entry

```http
POST /journal
```

Creates a new journal entry.

Example request:

```json
{
  "title": "My First Entry",
  "content": "Today I started learning Spring Boot."
}
```

### Update Entry

```http
PUT /journal/id/{myId}
```

Updates an existing journal entry using its ID.

### Delete Entry

```http
DELETE /journal/id/{myId}
```

Deletes the journal entry associated with the given ID.

Example:

```http
DELETE /journal/id/1
```

## How It Works

The application follows a simple REST-based architecture:

```text
Client
  |
  | HTTP Request
  v
Spring Boot Application
  |
  v
REST Controller
  |
  v
Journal Entry Logic
  |
  v
In-Memory Storage
  |
  v
JSON Response
```

The current implementation focuses on understanding the backend fundamentals before introducing a persistent database.

## Getting Started

### Prerequisites

Make sure you have the following installed:

* Java 25
* Maven
* Git
* Postman (optional, for API testing)

### Clone the Repository

```bash
git clone https://github.com/Saket-01-bit/Kitaab.git
cd Kitaab
```

### Run Using Maven Wrapper

#### Windows

```bash
mvnw.cmd spring-boot:run
```

#### macOS / Linux

```bash
./mvnw spring-boot:run
```

### Build the Project

```bash
./mvnw clean package
```

On Windows:

```bash
mvnw.cmd clean package
```

## Testing the API

You can use **Postman** to test the REST endpoints.

Typical workflow:

```text
POST
  ↓
Create Journal Entry
  ↓
GET
  ↓
View Journal Entries
  ↓
PUT
  ↓
Update Entry
  ↓
DELETE
  ↓
Remove Entry
```

The repository also contains Postman-related configuration for API testing.

## Current Storage

The current version uses **in-memory storage** for journal entries.

This makes the project useful for learning REST API development without introducing database configuration.

Because the data is stored in memory, journal entries may be lost when the application is restarted.

## Future Improvements

* Add MySQL/PostgreSQL database integration
* Introduce Spring Data JPA
* Add repository and service layers
* Add validation using Jakarta Validation
* Add global exception handling
* Add proper HTTP status codes
* Add authentication and authorization
* Add user-specific journals
* Add pagination and sorting
* Add unit and integration tests
* Add API documentation using Swagger/OpenAPI

## Learning Objectives

This project was developed to understand:

* Spring Boot fundamentals
* REST API development
* HTTP methods
* `@RestController`
* `@GetMapping`
* `@PostMapping`
* `@PutMapping`
* `@DeleteMapping`
* `@PathVariable`
* JSON request/response handling
* Maven project structure
* API testing with Postman
* Backend application flow

## Author

**Saket Jain**

GitHub: [Saket-01-bit](https://github.com/Saket-01-bit)

Portfolio: [saketjain.vercel.app](https://saketjain.vercel.app/)

---

## License

This project is intended for learning and development purposes.
