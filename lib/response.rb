class Response
  attr_reader(:fisher, :rank, :target, :card)

  def initialize(fisher, rank, target, card=nil)
    @fisher = fisher
    @rank = rank
    @target = target
    @card = card
  end

  def to_json
    {'fisher' => @fisher, 'rank' => @rank, 'target' => @target, 'card' => @card}.to_json
  end

  def self.from_json(object)
    data = JSON.load(object)
    self.new data['fisher'], data['rank'], data['target'], data['card']
  end
end
