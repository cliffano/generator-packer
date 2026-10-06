import json

conf = open('conf/packer/docker.json', 'r')
version = json.loads(conf.read())['version']

def test_message_transform_via_default(host):
    cmd = host.run_expect([0], 'docker run {{dockerhub_username}}/{{image_name}}')
    assert 'Original: Hello World' in cmd.stdout
    assert 'Reverse: dlroW olleH' in cmd.stdout
    assert 'Uppercase: HELLO WORLD' in cmd.stdout
    assert 'Lowercase: hello world' in cmd.stdout


def test_message_transform_via_latest_tag(host):
    cmd = host.run_expect([0], 'docker run {{dockerhub_username}}/{{image_name}}:latest --message "Hello Packer"')
    assert 'Original: Hello Packer' in cmd.stdout
    assert 'Reverse: rekcaP olleH' in cmd.stdout
    assert 'Uppercase: HELLO PACKER' in cmd.stdout
    assert 'Lowercase: hello packer' in cmd.stdout

# TODO: uncomment after publishing, replacing <arch> with the architecture
# this test runs against (amd64 or arm64) - each CI matrix job only builds
# and pushes its own architecture's tag, never the full multi-arch manifest.
# def test_message_transform_via_version_tag(host):
#     cmd = host.run_expect([0], f'docker run {{dockerhub_username}}/{{image_name}}:{version}-<arch>')
#     assert 'Original: Hello World' in cmd.stdout
