import pytest
import sys
import os

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from app.main import app

@pytest.fixture
def client():
    """配置 Flask 测试客户端"""
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_health_endpoint(client):
    """测试 /health 接口是否返回 200 和正确的 JSON"""
    res = client.get('/health')
    assert res.status_code == 200
    data = res.get_json()
    assert data['status'] == 'ok'

def test_version_endpoint(client):
    """测试 /version 接口"""
    res = client.get('/version')
    assert res.status_code == 200
    assert 'version' in res.get_json()

def test_index_page(client):
    """测试首页是否能正常打开"""
    res = client.get('/')
    assert res.status_code == 200