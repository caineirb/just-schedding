from fastapi import FastAPI
from pydantic import BaseModel

# Initialize FastAPI app
app = FastAPI()

# Define a Pydantic model
class User(BaseModel):
    name: str
    email: str
    age: int

# Define a POST endpoint using the Pydantic model
@app.post("/users")
def create_user(user: User):
    return {
        "message": f"Fuck you, {user.name}!",
        "email": user.email,
        "age": user.age
    }
