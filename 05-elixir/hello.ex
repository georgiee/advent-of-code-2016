defmodule Hello do
  @moduledoc false
  
  use Application

  def start(_type, _args) do
    Hello.Supervisor.start_link()
  end
end