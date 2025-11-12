# Manual Pre-commit Checks
# Run this before committing code when pre-commit hooks cannot be installed

Write-Host "Running pre-commit checks..." -ForegroundColor Cyan

Write-Host "`n[1/4] Running Ruff formatter..." -ForegroundColor Yellow
uv run ruff format .
if ($LASTEXITCODE -ne 0) {
    Write-Host "x Ruff format failed" -ForegroundColor Red
    exit 1
}
Write-Host "* Ruff format passed" -ForegroundColor Green

Write-Host "`n[2/4] Running Ruff linter..." -ForegroundColor Yellow
uv run ruff check . --fix
if ($LASTEXITCODE -ne 0) {
    Write-Host "x Ruff check failed" -ForegroundColor Red
    exit 1
}
Write-Host "* Ruff check passed" -ForegroundColor Green

Write-Host "`n[3/4] Running mypy type checker..." -ForegroundColor Yellow
uv run mypy src/
if ($LASTEXITCODE -ne 0) {
    Write-Host "x mypy failed" -ForegroundColor Red
    exit 1
}
Write-Host "* mypy passed" -ForegroundColor Green

Write-Host "`n[4/4] Running tests..." -ForegroundColor Yellow
uv run pytest --cov=src --cov-fail-under=0
if ($LASTEXITCODE -ne 0) {
    Write-Host "x Tests failed" -ForegroundColor Red
    exit 1
}
Write-Host "* Tests passed" -ForegroundColor Green

Write-Host "`nAll checks passed! Ready to commit." -ForegroundColor Green
