load("render.star", "render")

def main(config):
    return render.Root(
        delay = 500,
        child = render.Box(
            color= "#00f",
        ),
    )