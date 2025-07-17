import sys
import re
import json
from pymongo import MongoClient
import shlex

# Database  parameters
DB_USER = "admin_user"
DB_PASSWORD = "adminpassword"
DB_HOST = "localhost"
DB_PORT = 27017
DB_AUTHOR = "admin"  # Authentication database

# establish a connection with MONGODB
DB_URI = f"mongodb://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_AUTHOR}"
db_client = MongoClient(DB_URI)
blop_database = db_client["blog_database"]
blogpost_collection = blop_database["posts"]
comments_collection = blop_database["comments"]
blogs_collection = blop_database["blogs"]


# Generating a permalink for a blog post
def create_permalink(blog_name, title):
    return generate_permalink(blog_name, title)


def generate_permalink(blog_name, post_title):
    formatted_title = re.sub(r"[^0-9a-zA-Z]+", "_", post_title)
    return f"{blog_name}.{formatted_title}"


# Function that creates a new blog post and insert it into the posts collection.
def add_Blogpost(blog_name, user_name, title, post_body, tags, timestamp):
    new_permalink = create_permalink(blog_name, title)
    tag_list = tags.split(", ")
    post_document = {
        "permalink": new_permalink,
        "title": title,
        "postBody": post_body,
        "userName": user_name,
        "timestamp": timestamp,
        "tags": tag_list,
        "blogName": blog_name,
        "comments": []  # Initialising with an empty list for future comments
    }
    blogpost_collection.insert_one(post_document)
    blogs_collection.update_one(
        {"name": blog_name},
        {"$set": {"last_post_timestamp": timestamp}},
    )
    print(f"Post '{title}' inserted into blog '{blog_name}'.")


# Function to Adds a comment to an existing blog post.
def add_comment(blog_name, permalink, user_name, comment_text):
    comment_entry = {
        "blog_name": blog_name,
        "permalink": permalink,
        "user_name": user_name,
        "comment_text": comment_text
    }
    target_post = blogpost_collection.find_one({"permalink": permalink})
    if not target_post:
        print(f"Error: Post with permalink '{permalink}' doesn't exist")
        return
    blogpost_collection.update_one({"permalink": permalink}, {"$push": {"comments": comment_entry}})
    print(f"Comment added by '{user_name}' with permalink: {permalink}")


# function that marks a blog post as deleted by updating its content.
def delete_post(blog_name, permalink, user_name, deleted_at):
    update_result = blogpost_collection.find_one_and_update(
        {"permalink": permalink},
        {"$set": {"postBody": f"deleted by {user_name}", "timestamp": deleted_at}}
    )
    if not update_result:
        print(f"Error: Post with permalink '{permalink}'doesn't exist")
    else:
        print(f"Post with permalink '{permalink}' was deleted by '{user_name}' at {deleted_at}")


# Function that Retrieves and displays all posts from a specific blog.
def show_posts(blog_name):
    posts = blogpost_collection.find({"blogName": blog_name})
    print(f"Posts in blog '{blog_name}':")
    for post in posts:
        print("-" * 50)
        print(f"Title: {post['title']}")
        print(f"User: {post['userName']}")
        if post["tags"]:
            print(f"Tags: {', '.join(post['tags'])}")
        print(f"Timestamp: {post['timestamp']}")
        print(f"Permalink: {post['permalink']}")
        print("Content:")
        print(f"  {post['postBody']}")
        # Display comments for each post, if any exist
        for comment in post.get("comments", []):
            print(" " + "-" * 40)
            print(f"  User: {comment['user_name']}")
            print(f"  Permalink: {comment['permalink']}")
            print("  Comment:")
            print(f"    {comment['comment_text']}")


# Search for posts and comments in a specific blog that contain the search string.
def search_posts(blog_name, search_string):
    posts = blogpost_collection.find({"blogName": blog_name})
    print(f"Search results in blog '{blog_name}':")
    found_any = False
    for post in posts:
        # Check if the search string is in the post content or any of its tags
        if search_string in post["postBody"] or any(search_string in tag for tag in post["tags"]):
            found_any = True
            print("-" * 50)
            print(f"Title: {post['title']}")
            print(f"User: {post['userName']}")
            if post["tags"]:
                print(f"Tags: {', '.join(post['tags'])}")
            print(f"Timestamp: {post['timestamp']}")
            print(f"Permalink: {post['permalink']}")
            print("Content:")
            print(f"  {post['postBody']}")
        # Also check each comment for the search string
        for comment in post.get("comments", []):
            if search_string in comment["comment_text"]:
                found_any = True
                print(" " + "-" * 40)
                print(f"  User: {comment['user_name']}")
                print(f"  Permalink: {comment['permalink']}")
                print("  Comment:")
                print(f"    {comment['comment_text']}")
    if not found_any:
        print("No posts or comments matched the search criteria.")


def main():
    print("Welcome to Blogpost App!")
    print("Available commands: post, comment, delete, show, find, quit")

    # Mapping the command names to the expected number of parameters and the corresponding function
    command_map = {
        "post": {"expected": 6, "function": add_Blogpost},
        "comment": {"expected": 4, "function": add_comment},
        "delete": {"expected": 4, "function": delete_post},
        "show": {"expected": 1, "function": show_posts},
        "find": {"expected": 2, "function": search_posts}
    }

    while True:
        try:
            user_input = input("Command > ").strip()
            if not user_input:
                continue
            tokens = shlex.split(user_input)
            cmd = tokens[0].lower()

            # Exit condition for the command loop
            if cmd in ("exit", "quit"):
                print("Bloppost App is closing down. Until next time!")
                break

            if cmd in command_map:
                mapping = command_map[cmd]
                expected_count = mapping["expected"]
                function_to_call = mapping["function"]
                params = tokens[1:]
                if len(params) != expected_count:
                    print(f"Error: '{cmd}' requires {expected_count} parameters, but you provided {len(params)}.")
                    continue
                # Call the corresponding function
                function_to_call(*params)
            else:
                print("Invalid command entered. Please try again.")
        except (EOFError, KeyboardInterrupt):
            print("\nShutting down. Wishing you a great day ahead!")
            break


if __name__ == "__main__":
    main()
