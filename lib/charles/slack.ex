defmodule Charles.Slack do
  use Slack

  @token Application.get_env(:charles, __MODULE__)[:token]

  def start_link, do: start_link(@token, [])

  def handle_message(message = %{type: "message", text: text}, slack, state) do
    if text == "Hello <@#{slack.me.id}>" do
      Slack.send_message("Hello!", message.channel, slack)
    end

    if String.starts_with? text, "Hey <@#{slack.me.id}>, say" do
      say(text, message.channel, slack)
    end

    if String.starts_with? text, "Hey <@#{slack.me.id}>, salute" do
      salute(text, message.channel, slack)
    end

    {:ok, state}
  end

  def salute(text, channel, slack) do
    [command, message] = String.split(text, "salute")
    message = String.strip(message)
    Slack.send_message("@#{message}", channel, slack)
  end

  def say(text, channel, slack) do
    [command, message] = String.split(text, "say")
    Slack.send_message(message, channel, slack)
  end

  def handle_message(_message, _slack, state), do: {:ok, state}
end
