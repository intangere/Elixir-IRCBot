#Test IRC Connection Application written by Intangere

defmodule Irc do
  use Application
  
  def connect(host, port) do
    {:ok, socket} = :gen_tcp.connect(host, port, [:binary, active: false])
    sendAll(socket, "NICK Test_account")
    sendAll(socket, "USER Test_account Test_account Test_account :Test_account")
    IO.puts("Connected to #{host}.")
    loop(socket)
  end

  def sendAll(socket, data) do
    :gen_tcp.send(socket, data <> "\r\n")
    IO.puts("Sent")
  end

  def recv(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    IO.puts(data)
    data
  end

  def loop(socket) do 
    connected = true
    if connected == true do
      data = recv(socket)
      if data != "" do
        if String.slice(data, 0..3) == "PING" do
          pong = "PONG " <> List.last(String.split(data[1], " "))
          sendAll(socket, pong)
        end
        loop(socket)
      else
        connected = false
      end
    else
      IO.puts("Connection to server terminated.") 
    end
  end
end

Irc.connect('irc.freenode.net', 6667)
