# Docker Cleanup Command

Clean up unused Docker resources without affecting actively running containers.

## Instructions

Run the following commands to clean up Docker:

1. Remove stopped containers:

```bash
docker container prune -f
```

2. Remove dangling images (not tagged, not used):

```bash
docker image prune -f
```

3. Remove unused volumes:

```bash
docker volume prune -f
```

4. Remove unused networks:

```bash
docker network prune -f
```

5. Show current disk usage:

```bash
docker system df
```

Report what was cleaned up and how much space was reclaimed.

## Note

This is a SAFE cleanup - it will NOT remove:

- Running containers
- Images used by running containers
- Volumes attached to running containers
- Networks used by running containers
