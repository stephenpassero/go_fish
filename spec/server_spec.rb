require 'rspec'
require 'socket'
require_relative '../lib/server'
require_relative '../lib/card'
require 'pry'

class MockGoFishSocketClient
  attr_reader (:socket)
  attr_reader(:output)
  attr_reader(:server)

  def initialize(port)
    @socket = TCPSocket.new('localhost', port)
  end

  def provide_input(text)
    @socket.puts(text)
  end

  def capture_output(delay=0.1)
    sleep(delay)
    @output = @socket.read_nonblock(1000) # not gets which blocks
  rescue IO::WaitReadable
    @output = ""
  end

  def close
    @socket.close if @socket
  end
end

describe GoFishServer do
  before(:each) do
    @server = GoFishServer.new
    @clients = []
  end


  after(:each) do
    @server.stop
    @clients.each do |client|
      client.close
    end
  end

  it "is not listening on a port before it is started"  do
    expect {MockGoFishSocketClient.new(@server.port_number)}.to raise_error(Errno::ECONNREFUSED)
  end

  it "accepts clients" do
    @server.start
    client1 = MockGoFishSocketClient.new(@server.port_number)
    client1.provide_input("2")
    @server.accept_new_client("Player 1")
    expect(@server.pending_clients.length).to eq(1)
    client2 = MockGoFishSocketClient.new(@server.port_number)
    @server.accept_new_client("Player 2")
    expect(@server.pending_clients.length).to eq(2)
  end

  it "can create a game" do
    @server.start
    client1 = MockGoFishSocketClient.new(@server.port_number)
    client2 = MockGoFishSocketClient.new(@server.port_number)
    client1.provide_input("2")
    @server.accept_new_client("Player 1")
    @server.accept_new_client("Player 2")
    game = @server.create_game_if_possible()
    expect(game.players.length).to eq(2)
  end

  it "prompts the correct input to the correct players" do
    @server.start
    client1 = MockGoFishSocketClient.new(@server.port_number)
    client2 = MockGoFishSocketClient.new(@server.port_number)
    client1.provide_input("2")
    @server.accept_new_client("Player 1")
    @server.accept_new_client("Player 2")
    expect(client1.capture_output()).to include("How many people would you like to play with?")
    expect(client2.capture_output).to eq("Welcome! The the game will begin shortly. You are Player 2\n")
  end

  it "tells them what cards they have at the beginning of the game" do
    @server.start
    client1 = MockGoFishSocketClient.new(@server.port_number)
    client2 = MockGoFishSocketClient.new(@server.port_number)
    client1.provide_input("2")
    @server.accept_new_client("Player 1")
    @server.accept_new_client("Player 2")
    player_num = 1
    card1 = Card.new(6, "Diamonds")
    game = @server.create_game_if_possible()
    @server.set_player_hand(game, player_num, [card1])
    @server.tell_clients_their_hand(game)
    expect(client1.capture_output).to include("6-of-Diamonds")
  end

  it "should run an entire round" do
    @server.start
    client1 = MockGoFishSocketClient.new(@server.port_number)
    client2 = MockGoFishSocketClient.new(@server.port_number)
    client3 = MockGoFishSocketClient.new(@server.port_number)
    client1.provide_input("3")
    @server.accept_new_client("Player 1")
    @server.accept_new_client("Player 2")
    @server.accept_new_client("Player 3")
    game = @server.create_game_if_possible
    client1.provide_input("Ask player2 for a 8")
    @server.run_round(game)
    expect(client1.capture_output).to include("You asked player2 for a 8")
    expect(client2.capture_output).to include("Player1 asked you for a 8")
    expect(client3.capture_output).to include("Player1 asked player2 for a 8")
    expect(game.player_turn).to eq(2)
  end
end
