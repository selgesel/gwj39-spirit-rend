extends Node

class_name Spellcasting

const AllSpells = {
    "heal": preload("res://spells/Heal.tscn")
};

func cast(spell_name: String, target: Spatial, detection_mask: int):
    if !AllSpells.has(spell_name):
        return

    var spell: BaseSpell = AllSpells[spell_name].instance()
    spell.collision_mask = detection_mask
    add_child(spell)
    spell.call_deferred("cast", target)
    return spell
