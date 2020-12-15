require 'victor'

svg = Victor::SVG.new width: 200, height: 100, style: { background: '#ddd' }
svg = Victor::SVG.new width: 200, height: 100, style: { background: '#ddd' }

svg.build do
  g font_size: 30, font_family: 'arial', fill: 'green' do
    text "Scalable Victor Graphics", x: 40, y: 50
  end
  # rect x: 10, y: 10, width: 120, height: 80, rx: 10, fill: '#666'
  #
  # circle cx: 50, cy: 50, r: 30, fill: 'yellow'
  # circle cx: 58, cy: 32, r: 4, fill: 'black'
  # polygon points: %w[45,50 80,30 80,70], fill: '#666'
  #
  # 3.times do |i|
  #   x = 80 + i*18
  #   circle cx: x, cy: 50, r: 4, fill: 'yellow'
  # end
end

svg.save 'pacman'