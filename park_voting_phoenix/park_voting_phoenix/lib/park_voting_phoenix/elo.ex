defmodule ParkVotingPhoenix.Elo do
  @moduledoc """
  Provides ELO rating calculation.
  """

  @k 32

  @doc """
  Calculates new ELO ratings given two players' ratings.
  Returns {new_rating_winner, new_rating_loser}.
  """
  def calculate(r1, r2) do
    expected1 = 1.0 / (1.0 + :math.pow(10, (r2 - r1) / 400.0))
    expected2 = 1.0 / (1.0 + :math.pow(10, (r1 - r2) / 400.0))
    new_r1 = r1 + @k * (1.0 - expected1)
    new_r2 = r2 + @k * (0.0 - expected2)
    {Float.round(new_r1, 2), Float.round(new_r2, 2)}
  end
end
