# Coding standards

## Python backend

### Général

- Python 3.12+.
- Type hints obligatoires.
- Ruff pour lint/format.
- mypy pour contrôle de typage.
- pytest pour tests.
- Pydantic v2 pour schemas API.
- SQLAlchemy 2.x typed ORM.

### Architecture

- `api` : endpoints.
- `services` : logique métier.
- `repositories` : requêtes DB.
- `models` : SQLAlchemy.
- `schemas` : Pydantic.
- `connectors` : APIs externes.
- `analysis` : calculs financiers.

### Règles

- Une route FastAPI ne doit pas contenir de requête SQL directe.
- Un repository ne doit pas appeler d’API externe.
- Un connecteur ne doit pas écrire directement en DB.
- Les erreurs métier doivent être explicites.
- Les fonctions doivent être petites, testables et nommées clairement.
- Les montants financiers doivent utiliser `Decimal` côté Python quand c’est pertinent.

### Exemple attendu

```python
class InstrumentService:
    def __init__(self, repository: InstrumentRepository) -> None:
        self.repository = repository

    def search(self, query: str) -> list[InstrumentRead]:
        normalized_query = query.strip()
        if not normalized_query:
            return []
        return self.repository.search(normalized_query)
```

## TypeScript frontend

### Général

- TypeScript strict.
- React function components.
- Pas de `any` sauf justification.
- API client centralisé.
- UI sobre, lisible et orientée décision.

### Règles

- Ne pas appeler directement l’API dans plusieurs composants de façon dispersée.
- Les types de réponses API sont définis dans `src/types`.
- Chaque page doit gérer loading, error et empty state.
- Les composants de présentation ne contiennent pas de logique métier financière.

### Formatage financier

Créer des helpers :

- `formatCurrency(value, currency)` ;
- `formatPercent(value)` ;
- `formatDate(value)` ;
- `formatScore(value)`.

## Commits

Format recommandé :

- `feat: add instrument search endpoint`
- `fix: handle missing price history`
- `test: add RSI unit tests`
- `docs: update API contract`

## Tests

Backend :

- Les indicateurs techniques doivent avoir des tests unitaires.
- Les services critiques doivent avoir des tests.
- Les endpoints principaux doivent avoir au minimum des tests smoke.

Frontend :

- Tester les composants avec logique conditionnelle.
- Tester les formatters.
- Tester les states loading/error.
