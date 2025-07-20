class_name EnemyAttack
extends Resource

@export var name: String
@export var damage_modifier: float
@export var mp_use: int
@export var attack_type: EnemyAttackType

enum EnemyAttackType {
    NORMAL,
    MAGIC,
    PERCENTILE
}
