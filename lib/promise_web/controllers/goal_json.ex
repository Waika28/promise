defmodule PromiseWeb.GoalJSON do
  alias Promise.Goals.Goal

  @doc """
  Renders a list of goals.
  """
  def index(%{goals: goals, total_count: total_count}) do
    %{total_count: total_count, data: for(goal <- goals, do: data(goal))}
  end

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
      deadline: goal.deadline,
      user_id: goal.user_id,
      inserted_at: goal.inserted_at,
      done: goal.done,
      is_public: goal.is_public,
      is_joined: goal.is_joined
    }
  end
end
