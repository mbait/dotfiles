#!/usr/bin/python2.7

import i3

workspaces = [ws for ws in enumerate(i3.get_workspaces())]
focused_id = [i for i, ws in workspaces if ws['focused']][0]

i3.command('move', 'workspace to output left')
i3.workspace(workspaces[1 - focused_id][1]['name'])
i3.command('move', 'workspace to output right')
