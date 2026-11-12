"""Unit tests for hello.py — run in CI with pytest."""
from hello import compute_demo_stats, greeting, main


def test_greeting_default():
    assert greeting() == "Hello, World!"


def test_greeting_custom_name():
    assert greeting("Claude") == "Hello, Claude!"


def test_compute_demo_stats_shape():
    stats = compute_demo_stats(size=5)
    assert dict(stats)


def test_main_runs_and_returns_zero(capsys):
    rc = main(["CI"])
    captured = capsys.readouterr()
    assert rc == 0
    assert "Hello, CI!" in captured.out
