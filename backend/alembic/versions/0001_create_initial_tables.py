"""initial

Revision ID: 0001_create_initial_tables
Revises: 
Create Date: 2026-05-17

"""
from alembic import op
import sqlalchemy as sa

revision = '0001_create_initial_tables'
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    # NOTE: This is a scaffolded migration. Adjust types to match models.
    op.create_table(
        'exchanges',
        sa.Column('id', sa.Integer, primary_key=True),
        sa.Column('code', sa.String(16), nullable=False),
        sa.Column('name', sa.String(255), nullable=True),
    )


def downgrade() -> None:
    op.drop_table('exchanges')
