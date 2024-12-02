# Dog Shelter Management System (Motoko)

This project is a simple shelter management system implemented using Motoko, designed to manage the adoption, neutering, and overall tracking of dogs in a shelter. It includes various features such as adding, updating, deleting, and adopting dogs, along with advanced search and statistics functionality.

## Features

- **Add Dog**: Add a new dog to the shelter database.
- **Update Dog**: Update details of a dog in the shelter.
- **Delete Dog**: Remove a dog from the shelter database.
- **Adopt Dog**: Mark a dog as adopted.
- **Neuter Dog**: Mark a dog as neutered.
- **Get Dog by ID**: Retrieve a specific dog’s details using their ID.
- **List All Dogs**: List all dogs currently in the shelter.
- **Search Dogs**: Search for dogs based on various criteria (age, breed, adoption status, neutering status).
- **Shelter Statistics**: Get the statistics of the shelter, including total dogs, adopted dogs, available dogs, and neutered dogs.

## Data Model

### Dog
Each dog in the shelter has the following attributes:
- `name`: The name of the dog.
- `age`: The age of the dog (in years).
- `breed`: The breed of the dog.
- `isAdopted`: Boolean indicating whether the dog has been adopted.
- `isNeutered`: Boolean indicating whether the dog has been neutered.

### DogId
A unique identifier for each dog in the shelter.

### ResponseDog
The response format for a dog’s details, including the `id`.

### SearchCriteria
Criteria used for searching dogs, which can include:
- `minAge`: Minimum age of the dog.
- `maxAge`: Maximum age of the dog.
- `breed`: Breed of the dog.
- `isAdopted`: Adoption status of the dog.
- `isNeutered`: Neutering status of the dog.

## Functions

### addDog
Adds a new dog to the shelter with a unique ID.

### updateDog
Updates the details of an existing dog.

### deleteDog
Deletes a dog from the shelter database.

### adoptDog
Marks a dog as adopted.

### neuterDog
Marks a dog as neutered.

### getDog
Fetches a dog’s details by their unique ID.

### listAllDogs
Lists all dogs currently in the shelter.

### searchDogs
Searches for dogs based on multiple criteria (age, breed, adoption status, neutering status).

### getShelterStats
Returns statistics about the shelter, including:
- Total number of dogs.
- Number of adopted dogs.
- Number of available dogs.
- Number of neutered dogs.

## Setup

1. Install the [DFINITY SDK](https://sdk.dfinity.org/docs/index.html).
2. Clone this repository:

   ```bash
   git clone https://github.com/yourusername/dog-shelter-management.git
