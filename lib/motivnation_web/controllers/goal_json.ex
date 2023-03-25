defmodule MotivnationWeb.GoalJSON do
  alias Motivnation.Goals.Goal

  @doc """
  Renders a list of goals.
  """
  def index(%{goals: goals}) do
    %{data: for(goal <- goals, do: data(goal))}
  end

  @doc """
  Renders a single goal.
  """
  def show(%{goal: goal}) do
    %{data: data(goal)}
  end

  defp data(%Goal{} = goal) do
    %{
      id: goal.id,
      title: goal.title,
      user_id: goal.user_id
    }
  end
end
