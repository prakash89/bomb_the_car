require 'gosu'
require 'pry'
include Gosu

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = "Jump 'n Run"
    @bullet, @walk1, @walk2, @jump = Gosu::Image.load_tiles(self, "images/bullet.png", 20, 20, false)
    @standing, @walk1, @walk2, @jump = Gosu::Image.load_tiles(self, "images/car.png", 38, 15, false)
    @explosion, @walk1, @walk2, @jump = Gosu::Image.load_tiles(self, "images/explosion.png", 50, 50, false)
    @points_text = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @lives_text = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @game_over = Gosu::Font.new(self, Gosu::default_font_name, 40)
    @restart = Gosu::Font.new(self, Gosu::default_font_name, 11)
    @car_x,@car_y=300,400
    set_bullet_position
    @lives=3
    @loose = false
    @points=0
    @etime = 0
  end

  def update
  end

  def reset_point
    if (@loose == true)
      @points = 0
    end
  end

  def calcute_car_position
    case @pressed
       when 123, 105 then @car_x = @car_x-3
      when 124, 106 then @car_x = @car_x+3
      when 125, 108 then @car_y = @car_y+3
      when 126, 103 then @car_y = @car_y-3
      when 45, 49 then
        restart_game
    end
  end

  def restart_game
    @car_x,@car_y=300,400
    set_bullet_position
    @loose = false
    @lives = 3
  end

  def set_bullet_position
    @bullet1_x,@bullet1_y= rand(640), 500
    @bullet2_x,@bullet2_y= rand(600), 400
    @bullet3_x,@bullet3_y= rand(560), 300
    @bullet4_x,@bullet4_y= rand(520), 200
    @bullet5_x,@bullet5_y= rand(500), 150
    @bullet6_x,@bullet6_y= rand(480), 100 
  end

  def incrementing_bullet_y_position
    @bullet1_y = @bullet1_y+4
    @bullet2_y = @bullet2_y+4
    @bullet3_y = @bullet3_y+4
    @bullet4_y = @bullet4_y+4
    @bullet5_y = @bullet5_y+4
    @bullet6_y = @bullet6_y+4
  end

  def draw
   calcute_car_position
   unless @loose
    incrementing_bullet_position
    increment_point_for_miss_bullet
    bullets = [[@bullet1_x, @bullet1_y], [@bullet2_x, @bullet2_y],[@bullet3_x, @bullet3_y],[@bullet4_x, @bullet4_y],[@bullet5_x, @bullet5_y],[@bullet6_x, @bullet6_y]]
    bullets.each do |bullet|
      bullet_car_collision(bullet)
    end

    if @etime > 0
      @explosion.draw(@ex,@ey,1)
      @etime =@etime -1
    else
      fall_bullet_from_sky
      @standing.draw(@car_x, @car_y, 1)
    end
  else
    @game_over.draw("Game Over", 220, 220, 3.0, 1.0, 1.0, 0xffffffff)
    @game_over.draw("restart press 'n' ", 250, 250, 3.0, 1.0, 1.0, 0xffffffff)
  end

  @points_text.draw("Points: #{@points}", 10, 10, 3.0, 1.0, 1.0, 0xffffffff)
  @lives_text.draw("Lives: #{(1..@lives).map{|l| "X" }.join(" ")}", 450, 10, 3.0, 1.0, 1.0, 0xffffffff)
end

  def increment_point_for_miss_bullet
      if (@bullet1_y > 480) 
        @bullet1_y=0
        @bullet1_x=rand(640)
        @points = @points +1
      end
      if @bullet2_y > 480
        @bullet2_y=0
        @bullet2_x=rand(640)
        @points = @points+1
      end
      if @bullet3_y > 480
        @bullet3_y=0
        @bullet3_x=rand(640)
        @points = @points+1
      end
      if @bullet4_y > 480
        @bullet4_y=0
        @bullet4_x=rand(640)
        @points = @points+1
      end
      if @bullet5_y > 480
        @bullet5_y=0
        @bullet5_x=rand(640)
        @points = @points+1
      end
      if @bullet6_y > 480
        @bullet6_y=0
        @bullet6_x=rand(640)
        @points = @points+1
      end
  end

  def bullet_car_collision(bullet)
    if (bullet[1]+20 > @car_y && @car_y+15 > bullet[1]) && (bullet[0]+20 > @car_x && bullet[0] < @car_x+38 )
        @ex,@ey=@car_x,@car_y-25
        @car_x,@car_y=300,400
        bullet[0],bullet[0]= rand(640), 0
        @etime = 20
        @lives= @lives-1
        if @lives < 1
          @loose = true
          reset_point
        end
      end
  end

  def fall_bullet_from_sky
    @bullet.draw(@bullet1_x, @bullet1_y, 0.5)
    @bullet.draw(@bullet2_x, @bullet2_y, 0.5)
    @bullet.draw(@bullet3_x, @bullet3_y, 0.5)
    @bullet.draw(@bullet4_x, @bullet4_y, 0.5)
    @bullet.draw(@bullet5_x, @bullet5_y, 0.5)
    @bullet.draw(@bullet6_x, @bullet6_y, 0.5)
  end

  def button_down(id)
    @pressed = id
  end

  def button_up(id)
    @pressed = nil
  end


end

window = GameWindow.new
window.show