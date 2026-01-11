"""merge multiple migration heads

Revision ID: 17d6dffeee1f
Revises: e06bd9a9ed13, 362df1345cbe, 691a67563d0b
Create Date: 2026-01-11 11:05:49.789850

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '17d6dffeee1f'
down_revision = ('e06bd9a9ed13', '362df1345cbe', '691a67563d0b')
branch_labels = None
depends_on = None


def upgrade():
    pass


def downgrade():
    pass
