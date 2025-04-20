import pygame
import random
import time
import psycopg2
import json
import sys

# Подключение к базе данных
conn = psycopg2.connect(
    dbname="snake_db",
    user="postgres",
    password="kotyanya",  
    host="localhost",
    port="5432"
)
cur = conn.cursor()

def get_or_create_user():
    username = input("Enter your username: ")
    cur.execute("SELECT id FROM game_user WHERE username = %s", (username,))
    user = cur.fetchone()
    if user:
        user_id = user[0]
        print(f"Welcome back, {username}!")
    else:
        cur.execute("INSERT INTO game_user (username) VALUES (%s) RETURNING id", (username,))
        user_id = cur.fetchone()[0]
        conn.commit()
        print(f"New user {username} created!")
    return user_id, username

def save_game(user_id, level, score, snake, food, direction):
    state = {
        "snake": snake,
        "food": food,
        "direction": direction
    }
    cur.execute(
        "INSERT INTO user_score (user_id, level, score, state) VALUES (%s, %s, %s, %s)",
        (user_id, level, score, json.dumps(state))
    )
    conn.commit()
    print("Game paused and saved.")
    pygame.quit()
    sys.exit()

# Получение пользователя
user_id, username = get_or_create_user()

# Инициализация игры
pygame.init()
WIDTH, HEIGHT = 600, 400
CELL_SIZE = 20
WHITE = (255, 255, 255)
GREEN = (0, 255, 0)
RED = (255, 0, 0)
BLACK = (0, 0, 0)
YELLOW = (255, 255, 0)
BLUE = (0, 0, 255)

screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Snake Game with PostgreSQL")

snake = [(100, 100), (80, 100), (60, 100)]
snake_dir = (CELL_SIZE, 0)

def generate_food():
    while True:
        pos = (random.randint(0, (WIDTH - CELL_SIZE) // CELL_SIZE) * CELL_SIZE,
               random.randint(0, (HEIGHT - CELL_SIZE) // CELL_SIZE) * CELL_SIZE)
        if pos not in snake:
            food_type = random.choice([(RED, 1), (YELLOW, 2), (BLUE, 3)])
            return pos, food_type

food, food_type = generate_food()
food_timer = time.time()
score = 0
level = 1
speed = 10
running = True
clock = pygame.time.Clock()

while running:
    screen.fill(BLACK)
    pygame.time.delay(50)

    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            save_game(user_id, level, score, snake, food, snake_dir)
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_UP and snake_dir != (0, CELL_SIZE):
                snake_dir = (0, -CELL_SIZE)
            elif event.key == pygame.K_DOWN and snake_dir != (0, -CELL_SIZE):
                snake_dir = (0, CELL_SIZE)
            elif event.key == pygame.K_LEFT and snake_dir != (CELL_SIZE, 0):
                snake_dir = (-CELL_SIZE, 0)
            elif event.key == pygame.K_RIGHT and snake_dir != (-CELL_SIZE, 0):
                snake_dir = (CELL_SIZE, 0)
            elif event.key == pygame.K_p:
                save_game(user_id, level, score, snake, food, snake_dir)

    new_head = (snake[0][0] + snake_dir[0], snake[0][1] + snake_dir[1])

    if new_head[0] < 0 or new_head[0] >= WIDTH or new_head[1] < 0 or new_head[1] >= HEIGHT or new_head in snake:
        print("Game Over!")
        save_game(user_id, level, score, snake, food, snake_dir)

    snake.insert(0, new_head)

    if new_head == food:
        score += food_type[1]
        food, food_type = generate_food()
        food_timer = time.time()
        if score % 4 == 0:
            level += 1
            speed += 2
    else:
        snake.pop()

    if time.time() - food_timer > 5:
        food, food_type = generate_food()
        food_timer = time.time()

    for segment in snake:
        pygame.draw.rect(screen, GREEN, (*segment, CELL_SIZE, CELL_SIZE))

    pygame.draw.rect(screen, food_type[0], (*food, CELL_SIZE, CELL_SIZE))

    font = pygame.font.Font(None, 30)
    score_text = font.render(f"Score: {score}  Level: {level}", True, WHITE)
    screen.blit(score_text, (10, 10))

    pygame.display.flip()
    clock.tick(speed)

pygame.quit()
cur.close()
conn.close()
