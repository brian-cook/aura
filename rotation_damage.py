import json
import os
import random

class Rogue:
    def __init__(self, level=10, use_backstab=True, use_buffs=True):
        self.level = level
        self.energy = 100
        self.combo_points = 0
        self.time = 0
        self.damage = 0
        self.gcd = 1
        self.energy_tick_rate = 2
        self.energy_per_tick = 20
        self.next_energy_tick = self.energy_tick_rate
        self.use_backstab = use_backstab
        self.use_buffs = use_buffs
        self.crit_chance = 0.2  # 20% critical hit chance
        self.hit_chance = 0.95  # 95% hit chance
        self.weapon_damage_min = 71  # Example weapon damage (min)
        self.weapon_damage_max = 107  # Example weapon damage (max)
        self.attack_speed = 1.8  # Example weapon attack speed
        self.target_health = 4000  # Defias Pillager health
        self.target_armor = 50  # Defias Pillager armor
        self.slice_and_dice_active = False
        self.slice_and_dice_end_time = 0
        self.adrenaline_rush_active = False
        self.adrenaline_rush_end_time = 0
        self.last_energy_tick_time = 0
        self.player_behind_target = False  # Assume player is facing the mob

    def calculate_damage(self, base_damage, multiplier, additional_damage=0):
        if random.random() > self.hit_chance:
            print(f"Missed attack: Time={self.time}")
            return 0
        weapon_damage = random.randint(self.weapon_damage_min, self.weapon_damage_max)
        damage = base_damage + weapon_damage * multiplier + additional_damage
        damage = damage * (1 - self.target_armor / (self.target_armor + 400 + 85 * self.level))  # Armor reduction
        if random.random() < self.crit_chance:
            damage *= 2
            print(f"Critical hit: Time={self.time}, Damage={damage}")
        elif random.random() < 0.4:  # Glancing blow chance
            damage *= 0.7
            print(f"Glancing blow: Time={self.time}, Damage={damage}")
        return damage

    def backstab(self):
        if self.use_backstab and self.energy >= 60:
            self.energy -= 60
            self.combo_points += 1
            if self.player_behind_target:
                damage = self.calculate_damage(150, 1.5, 150)  # Base damage, multiplier, and additional damage
                self.damage += damage
                print(f"Used Backstab: Time={self.time}, Energy={self.energy}, Combo Points={self.combo_points}, Damage={self.damage}")
            else:
                print(f"Attempted Backstab but not behind target: Time={self.time}")
            self.time += self.gcd
            return True
        return False

    def sinister_strike(self):
        if self.energy >= 45:
            self.energy -= 45
            self.combo_points += 1
            damage = self.calculate_damage(7, 1.0, 7)  # Base damage, multiplier, and additional damage
            self.damage += damage
            self.time += self.gcd
            print(f"Used Sinister Strike: Time={self.time}, Energy={self.energy}, Combo Points={self.combo_points}, Damage={self.damage}")
            return True
        return False

    def sinister_strike_with_pooling(self):
        if self.energy >= 45 and self.energy_tick_check():
            self.energy -= 45
            self.combo_points += 1
            damage = self.calculate_damage(7, 1.0, 7)  # Base damage, multiplier, and additional damage
            self.damage += damage
            self.time += self.gcd
            print(f"Used Sinister Strike with pooling: Time={self.time}, Energy={self.energy}, Combo Points={self.combo_points}, Damage={self.damage}")
            return True
        return False

    def eviscerate(self):
        if self.energy >= 35 and self.combo_points >= 2:
            self.energy -= 35
            damage = 60 * self.combo_points  # Damage per combo point
            self.damage += damage
            self.combo_points = 0
            self.time += self.gcd
            print(f"Used Eviscerate: Time={self.time}, Energy={self.energy}, Combo Points={self.combo_points}, Damage={self.damage}")
            return True
        return False

    def slice_and_dice(self):
        if self.use_buffs and self.energy >= 25 and self.combo_points > 0:
            self.energy -= 25
            self.slice_and_dice_active = True
            self.slice_and_dice_end_time = self.time + 30  # Slice and Dice duration
            self.time += self.gcd
            print(f"Used Slice and Dice: Time={self.time}, Energy={self.energy}, Combo Points={self.combo_points}")
            return True
        return False

    def adrenaline_rush(self):
        if self.energy >= 0:
            self.adrenaline_rush_active = True
            self.adrenaline_rush_end_time = self.time + 15  # Adrenaline Rush duration
            self.time += self.gcd
            print(f"Used Adrenaline Rush: Time={self.time}")
            return True
        return False

    def regenerate_energy(self):
        if self.time >= self.next_energy_tick:
            energy_gain = self.energy_per_tick * 2 if self.adrenaline_rush_active else self.energy_per_tick
            self.energy = min(100, self.energy + energy_gain)
            self.next_energy_tick += self.energy_tick_rate
            self.last_energy_tick_time = self.time
            print(f"Regenerated Energy: Time={self.time}, Energy={self.energy}")

    def energy_tick_check(self):
        time_since_last_tick = self.time - self.last_energy_tick_time
        time_to_next_tick = self.energy_tick_rate - time_since_last_tick
        return time_to_next_tick <= 1

    def check_conditions(self, conditions):
        for condition in conditions:
            if condition == "combo_points_5" and self.combo_points < 5:
                return False
            if condition == "combo_points_4" and self.combo_points < 4:
                return False
            if condition == "combo_points_3" and self.combo_points < 3:
                return False
            if condition == "combo_points_2" and self.combo_points < 2:
                return False
            if condition == "power_60" and self.energy < 60:
                return False
            if condition == "power_45" and self.energy < 45:
                return False
            if condition == "power_35" and self.energy < 35:
                return False
            if condition == "slice_and_dice_buff" and not self.slice_and_dice_active:
                return False
            if condition == "adrenaline_rush" and not self.adrenaline_rush_active:
                return False
            if condition == "!target_health_under_75" and self.target_health < 0.75 * 4000:
                return False
            if condition == "target_health_under_75" and self.target_health >= 0.75 * 4000:
                return False
            if condition == "target_health_under_50" and self.target_health >= 0.5 * 4000:
                return False
            if condition == "target_health_under_35" and self.target_health >= 0.35 * 4000:
                return False
            if condition == "!player_not_behind_target" and not self.player_behind_target:
                return False
            if condition == "range_8":
                continue  # Assuming always in range for simplicity
            if condition == "energy_tick_check" and not self.energy_tick_check():
                return False
            if condition == "energy_above_45" and self.energy < 45:
                return False
        return True

    def simulate_rotation(self, duration, profile):
        while self.time < duration and self.target_health > 0:
            self.regenerate_energy()
            action_taken = False
            for action in profile["actions"]:
                print(f"Checking action: {action['name']}, Conditions: {action['conditions']}")
                if not self.check_conditions(action["conditions"]):
                    print(f"Skipping action {action['name']} due to unmet conditions")
                    continue
                if action["name"].startswith("Backstab") and self.backstab():
                    action_taken = True
                    break
                elif action["name"].startswith("Sinister Strike with energy pooling") and self.sinister_strike_with_pooling():
                    action_taken = True
                    break
                elif action["name"].startswith("Sinister Strike") and self.sinister_strike():
                    action_taken = True
                    break
                elif action["name"].startswith("cast Eviscerate") and self.eviscerate():
                    action_taken = True
                    break
                elif action["name"].startswith("Slice and Dice") and self.slice_and_dice():
                    action_taken = True
                    break
                elif action["name"].startswith("Adrenaline Rush") and self.adrenaline_rush():
                    action_taken = True
                    break
            if not action_taken:
                print(f"No action taken: Time={self.time}, Energy={self.energy}, Combo Points={self.combo_points}")
                self.time += self.gcd  # Increment time to avoid infinite loop
            if self.slice_and_dice_active and self.time >= self.slice_and_dice_end_time:
                self.slice_and_dice_active = False
                print(f"Slice and Dice expired: Time={self.time}")
            if self.adrenaline_rush_active and self.time >= self.adrenaline_rush_end_time:
                self.adrenaline_rush_active = False
                print(f"Adrenaline Rush expired: Time={self.time}")
            self.target_health -= self.damage
        return self.damage

# Load the profile from the relative path
profile_path = os.path.join('scripts', 'profiles', 'rogue_simulator.json')
try:
    with open(profile_path, 'r') as file:
        profile = json.load(file)
except FileNotFoundError:
    print(f"Error: The file 'rogue_simulator.json' was not found at {profile_path}")
    exit(1)

# Simulate a 60-second rotation for a level 10 Rogue without Backstab and without buffs
rogue = Rogue(level=10, use_backstab=False, use_buffs=False)
damage = rogue.simulate_rotation(60, profile)
print(f"Total damage dealt in 60 seconds: {damage}")