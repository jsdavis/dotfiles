#!/usr/bin/env python3.7

import asyncio  # noqa
import iterm2  # type: ignore

from typing import Union, Iterable

DARK_THEME = 'Solarized Dark (fixed)'
LIGHT_THEME = 'Solarized Light (fixed)'


async def changeTheme(connection, current_theme: Union[Iterable[str], str]) -> None:
    if isinstance(current_theme, str):
        current_theme = current_theme.split(' ')
    current_theme = set(part.lower() for part in current_theme)

    if 'dark' in current_theme:
        theme = DARK_THEME
    else:
        theme = LIGHT_THEME

    preset = await iterm2.ColorPreset.async_get(connection, theme)

    # Update the list of all profiles and iterate over them.
    profiles = await iterm2.PartialProfile.async_query(connection)
    for partial in profiles:
        # Fetch the full profile and then set the color preset in it.
        profile = await partial.async_get_full_profile()
        await profile.async_set_color_preset(preset)


async def main(connection) -> None:

    app = await iterm2.async_get_app(connection)
    initial_theme: str = await app.async_get_theme()
    await changeTheme(connection, initial_theme)

    async with iterm2.VariableMonitor(
        connection, iterm2.VariableScopes.APP, 'effectiveTheme', None
    ) as mon:
        while True:
            # Block until theme changes
            theme: str = await mon.async_get()

            # Themes have space-delimited attributes, one of which will be light or dark.
            await changeTheme(connection, theme)


iterm2.run_forever(main)
