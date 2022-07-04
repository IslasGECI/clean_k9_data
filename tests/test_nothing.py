import clean_k9_data as k9


def test_return_one():
    expected = 1
    obtained = k9.return_one()
    assert expected == obtained
