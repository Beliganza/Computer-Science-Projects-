## Functions Overview

- **create_permalink & generate_permalink**  
  *Purpose:* Generate a unique permalink for each blog post by replacing non-alphanumeric characters in the title with underscores.
  *Relevance:* Ensures that every blog post has a consistent, unique identifier.

- **add_Blogpost**  
  *Purpose:* Create a new blog post by constructing a post document (including title, body, tags, etc.) and inserting it into the database. It also updates the blog's data with the latest post timestamp.  
  *Data Structures:*  
  - Uses a dictionary to represent the post document.  
  - The tags are stored as a list of strings.  
  - The comments field is initialized as an empty list to store future comment dictionaries.  
  *Relevance:* Serves as the primary function for adding new content to the blog.

- **add_comment**  
  *Purpose:* Append a comment to an existing blog post by validating the post’s existence and updating its comments array.  
  *Data Structures:*  
  - Creates a dictionary for the comment entry.  
  
- **delete_post**  
  *Purpose:* Mark a blog post as deleted by updating its content, replacing the post body with a deletion notice.  
  *Data Structures:*  
  - Utilizes a dictionary update to modify keys 
- **show_posts**  
  *Purpose:* Retrieve and display all posts from a specific blog, including their associated comments.  

- **search_posts**  
  *Purpose:* Search through posts and their comments for a given keyword, and display any matches.  
  *Data Structures:*  
  - Iterates over a cursor of post dictionaries.  
  - Checks string fields and iterates through lists within these dictionaries.  

- **main**  
  *Purpose:* This is the entry point of the application, providing an interactive command-line loop that accepts user commands and dispatches them to the appropriate functions.  
  *Data Structures:*  
  - Uses a dictionary (`command_map`) to map command names to expected parameter counts and their corresponding function references.  
  - Processes user input as a list of strings (using the `shlex` module).  
  *Relevance:* Ties all functionalities together and facilitates user interaction with the Blogpost App.
