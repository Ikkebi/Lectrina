<?php

require_once __DIR__ . "/../database.php";

class StreakChecker {
    private array $user;

    private bool $is_expired   = false;
    private bool $is_increased = false;
    private ?int $new_streak   = null;

    public function __construct(
        array $user
    ) {
        $this->user = $user;
    }

    private function updateDatabase(): bool {
        if ($this->is_expired) {
            return database()
                ->prepare("UPDATE user SET streak = 0, last_streak_date = null WHERE id = ?")
                ->execute([$this->user["id"]]);
        } else if ($this->is_increased) {
            $today = date("Y-m-d");

            $this->new_streak = $this->user["streak"] + 1;

            return database()
                ->prepare("UPDATE user SET streak = ?, last_streak_date = ? WHERE id = ?")
                ->execute([$this->new_streak, $today, $this->user["id"]]);
        }

        // Burde ikke komme herned
        return true;
    }

    public function check(bool $is_login): bool {
        $last_streak_date = \DateTime::createFromFormat("Y-m-d", $this->user["last_streak_date"]);

        if (!$last_streak_date) {
            $this->is_increased = true;
        } else {
            $today            = new DateTime();

            $days_between = $last_streak_date->diff($today)->days;

            if ($days_between === 1) {
                $this->is_increased = true;
            } else if ($days_between > 1) {
                $this->is_expired = true;
            } else {
                // samme dato
                return true;
            }
        }

        if ($this->is_increased && $is_login) {
            // skal ikke sættes op hvis det bare er login tjek
            $this->is_increased = false;
            return true;
        }

        return $this->updateDatabase();
    }

    public function isExpired(): bool {
        return $this->is_expired;
    }

    public function isIncreased(): bool {
        return $this->is_increased;
    }

    public function getNewStreak(): ?int {
        return $this->new_streak;
    }
}