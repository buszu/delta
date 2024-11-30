# frozen_string_literal: true

require "ruby2d"

WIDTH = 1280
HEIGHT = 640

HERO_BASE_X = 50
HERO_BASE_Y = 191
HERO_MAX_WIDTH = 528
HERO_HEIGHT = 452

SQUARE_BASE_POSITIONS = [1250, 1500, 1750].freeze
SQUARE_SPEEDS = [7, 8, 9, 10].freeze

ESCAPE = "escape"
SPACE = "space"

RUNNING = "running"
JUMPING = "jumping"
FALLING = "falling"

set title: "Delta the Boxer"
set width: WIDTH
set height: HEIGHT

def escape?(event)
  event.key == ESCAPE
end

def space?(event)
  event.key == SPACE
end

def fall(hero)
  hero.y += 1 until hero.y == HERO_BASE_Y
end

def collision?(obstacle, hero)
  obstacle.contains?(
    hero.x + HERO_MAX_WIDTH,
    hero.y + HERO_HEIGHT
  )
end

Image.new(
  "images/land.png",
  width: WIDTH,
  height: HEIGHT
)

hero_state = RUNNING

delta = Sprite.new(
  "images/delta2.png",
  x: HERO_BASE_X,
  y: HERO_BASE_Y,
  animations: {
    run: [
      {
        x: 0, y: 0,
        width: 459, height: 452
      },
      {
        x: 460, y: 0,
        width: 528, height: 452
      }
    ],
    jump: [
      {
        x: 460, y: 0,
        width: 528, height: 452
      }
    ]
  }
)

delta.play(animation: :run, loop: true)

on :key_down do |event|
  close if escape?(event)
  next unless space?(event)
  next unless hero_state == RUNNING

  hero_state = JUMPING

  delta.y -= 50
  delta.play(animation: :jump, loop: true)
end

on :key_held do |event|
  next unless space?(event)
  next unless hero_state == JUMPING

  if delta.y >= HERO_BASE_Y - 50 - 150
    delta.y -= 3
  else
    hero_state = FALLING
  end

  fall(delta) if hero_state == FALLING
end
 
on :key_up do |event|
  next unless space?(event)

  fall(delta)
  hero_state = RUNNING
  delta.play(animation: :run, loop: true)
end

square = Square.new(
  x: HERO_BASE_X + 1250,
  y: HERO_BASE_Y + 402,
  color: "black",
  size: 50
)

speed = SQUARE_SPEEDS.sample
update do
  if square.x > 0
    square.x -= speed
  else
    square.x = HERO_BASE_X + SQUARE_BASE_POSITIONS.sample
    speed = SQUARE_SPEEDS.sample
  end

  puts "collision" if collision?(square, delta)
end

show
