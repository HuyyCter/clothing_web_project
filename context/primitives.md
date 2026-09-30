# Design Primitives

> Nguồn: resource.css (Figma export, style Tailwind). Đây là kho giá trị THÔ — dùng để tạo Token semantic, không dùng trực tiếp trong component.

## Colors

Mỗi nhóm màu có scale 50 → 950 (nhạt → đậm).

### Base
| Step | Variable | Hex |
|---|---|---|
| black | `--color-base-black` | `#000000FF` |
| white | `--color-base-white` | `#FFFFFFFF` |
| transparent | `--color-base-transparent` | `#FFFFFF00` |

### Slate
| Step | Variable | Hex |
|---|---|---|
| 50 | `--color-slate-50` | `#F8FAFCFF` |
| 100 | `--color-slate-100` | `#F1F5F9FF` |
| 200 | `--color-slate-200` | `#E2E8F0FF` |
| 300 | `--color-slate-300` | `#CAD5E2FF` |
| 400 | `--color-slate-400` | `#90A1B9FF` |
| 500 | `--color-slate-500` | `#62748EFF` |
| 600 | `--color-slate-600` | `#45556CFF` |
| 700 | `--color-slate-700` | `#314158FF` |
| 800 | `--color-slate-800` | `#1D293DFF` |
| 900 | `--color-slate-900` | `#0F172BFF` |
| 950 | `--color-slate-950` | `#020618FF` |

### Gray
| Step | Variable | Hex |
|---|---|---|
| 50 | `--color-gray-50` | `#F9FAFBFF` |
| 100 | `--color-gray-100` | `#F3F4F6FF` |
| 200 | `--color-gray-200` | `#E5E7EBFF` |
| 300 | `--color-gray-300` | `#D1D5DCFF` |
| 400 | `--color-gray-400` | `#99A1AFFF` |
| 500 | `--color-gray-500` | `#6A7282FF` |
| 600 | `--color-gray-600` | `#4A5565FF` |
| 700 | `--color-gray-700` | `#364153FF` |
| 800 | `--color-gray-800` | `#1E2939FF` |
| 900 | `--color-gray-900` | `#101828FF` |
| 950 | `--color-gray-950` | `#030712FF` |

### Zinc
| Step | Variable | Hex |
|---|---|---|
| 50 | `--color-zinc-50` | `#FAFAFAFF` |
| 100 | `--color-zinc-100` | `#F4F4F5FF` |
| 200 | `--color-zinc-200` | `#E4E4E7FF` |
| 300 | `--color-zinc-300` | `#D4D4D8FF` |
| 400 | `--color-zinc-400` | `#9F9FA9FF` |
| 500 | `--color-zinc-500` | `#71717BFF` |
| 600 | `--color-zinc-600` | `#52525CFF` |
| 700 | `--color-zinc-700` | `#3F3F46FF` |
| 800 | `--color-zinc-800` | `#27272AFF` |
| 900 | `--color-zinc-900` | `#18181BFF` |
| 950 | `--color-zinc-950` | `#09090BFF` |

### Neutral
| Step | Variable | Hex |
|---|---|---|
| 50 | `--color-neutral-50` | `#FAFAFAFF` |
| 100 | `--color-neutral-100` | `#F5F5F5FF` |
| 200 | `--color-neutral-200` | `#E5E5E5FF` |
| 300 | `--color-neutral-300` | `#D4D4D4FF` |
| 400 | `--color-neutral-400` | `#A1A1A1FF` |
| 500 | `--color-neutral-500` | `#737373FF` |
| 600 | `--color-neutral-600` | `#525252FF` |
| 700 | `--color-neutral-700` | `#404040FF` |
| 800 | `--color-neutral-800` | `#262626FF` |
| 900 | `--color-neutral-900` | `#171717FF` |
| 950 | `--color-neutral-950` | `#0A0A0AFF` |

### Stone
| Step | Variable | Hex |
|---|---|---|
| 50 | `--color-stone-50` | `#FAFAF9FF` |
| 100 | `--color-stone-100` | `#F5F5F4FF` |
| 200 | `--color-stone-200` | `#E7E5E4FF` |
| 300 | `--color-stone-300` | `#D6D3D1FF` |
| 400 | `--color-stone-400` | `#A6A09BFF` |
| 500 | `--color-stone-500` | `#79716BFF` |
| 600 | `--color-stone-600` | `#57534DFF` |
| 700 | `--color-stone-700` | `#44403BFF` |
| 800 | `--color-stone-800` | `#292524FF` |
| 900 | `--color-stone-900` | `#1C1917FF` |
| 950 | `--color-stone-950` | `#0C0A09FF` |

### Red
| Step | Variable | Hex |
|---|---|---|
| 50 | `--color-red-50` | `#FEF2F2FF` |
| 100 | `--color-red-100` | `#FFE2E2FF` |
| 200 | `--color-red-200` | `#FFC9C9FF` |
| 300 | `--color-red-300` | `#FFA2A2FF` |
| 400 | `--color-red-400` | `#FF6467FF` |
| 500 | `--color-red-500` | `#FB2C36FF` |
| 600 | `--color-red-600` | `#E7000BFF` |
| 700 | `--color-red-700` | `#C10007FF` |
| 800 | `--color-red-800` | `#9F0712FF` |
| 900 | `--color-red-900` | `#82181AFF` |
| 950 | `--color-red-950` | `#460809FF` |

### Orange
| Step | Variable | Hex |
|---|---|---|
| 50 | `--color-orange-50` | `#FFF7EDFF` |
| 100 | `--color-orange-100` | `#FFEDD4FF` |
| 200 | `--color-orange-200` | `#FFD6A8FF` |
| 300 | `--color-orange-300` | `#FFB86AFF` |
| 400 | `--color-orange-400` | `#FF8904FF` |
| 500 | `--color-orange-500` | `#FF6900FF` |
| 600 | `--color-orange-600` | `#F54A00FF` |
| 700 | `--color-orange-700` | `#CA3500FF` |
| 800 | `--color-orange-800` | `#9F2D00FF` |
| 900 | `--color-orange-900` | `#7E2A0CFF` |
| 950 | `--color-orange-950` | `#441306FF` |

### Amber
| Step | Variable | Hex |
|---|---|---|
| 50 | `--color-amber-50` | `#FFFBEBFF` |
| 100 | `--color-amber-100` | `#FEF3C6FF` |
| 200 | `--color-amber-200` | `#FEE685FF` |
| 300 | `--color-amber-300` | `#FFD230FF` |
| 400 | `--color-amber-400` | `#FFBA00FF` |
| 500 | `--color-amber-500` | `#FD9A00FF` |
| 600 | `--color-amber-600` | `#E17100FF` |
| 700 | `--color-amber-700` | `#BB4D00FF` |
| 800 | `--color-amber-800` | `#973C00FF` |
| 900 | `--color-amber-900` | `#7B3306FF` |
| 950 | `--color-amber-950` | `#461901FF` |

### Yellow
| Step | Variable | Hex |
|---|---|---|
| 50 | `--color-yellow-50` | `#FEFCE8FF` |
| 100 | `--color-yellow-100` | `#FEF9C2FF` |
| 200 | `--color-yellow-200` | `#FFF085FF` |
| 300 | `--color-yellow-300` | `#FFDF20FF` |
| 400 | `--color-yellow-400` | `#FCC800FF` |
| 500 | `--color-yellow-500` | `#EFB100FF` |
| 600 | `--color-yellow-600` | `#D08700FF` |
| 700 | `--color-yellow-700` | `#A65F00FF` |
| 800 | `--color-yellow-800` | `#894B00FF` |
| 900 | `--color-yellow-900` | `#733E0AFF` |
| 950 | `--color-yellow-950` | `#432004FF` |

### Lime
| Step | Variable | Hex |
|---|---|---|
| 50 | `--color-lime-50` | `#F7FEE7FF` |
| 100 | `--color-lime-100` | `#ECFCCAFF` |
| 200 | `--color-lime-200` | `#D8F999FF` |
| 300 | `--color-lime-300` | `#BBF451FF` |
| 400 | `--color-lime-400` | `#9AE600FF` |
| 500 | `--color-lime-500` | `#7CCF00FF` |
| 600 | `--color-lime-600` | `#5EA500FF` |
| 700 | `--color-lime-700` | `#497D00FF` |
| 800 | `--color-lime-800` | `#3D6300FF` |
| 900 | `--color-lime-900` | `#35530EFF` |
| 950 | `--color-lime-950` | `#192E03FF` |

### Green
| Step | Variable | Hex |
|---|---|---|
| 50 | `--color-green-50` | `#F0FDF4FF` |
| 100 | `--color-green-100` | `#DCFCE7FF` |
| 200 | `--color-green-200` | `#B9F8CFFF` |
| 300 | `--color-green-300` | `#7BF1A8FF` |
| 400 | `--color-green-400` | `#05DF72FF` |
| 500 | `--color-green-500` | `#00C951FF` |
| 600 | `--color-green-600` | `#00A63EFF` |
| 700 | `--color-green-700` | `#008236FF` |
| 800 | `--color-green-800` | `#016630FF` |
| 900 | `--color-green-900` | `#0D542BFF` |
| 950 | `--color-green-950` | `#052E16FF` |

### Emerald
| Step | Variable | Hex |
|---|---|---|
| 50 | `--color-emerald-50` | `#ECFDF5FF` |
| 100 | `--color-emerald-100` | `#D0FAE5FF` |
| 200 | `--color-emerald-200` | `#A4F4CFFF` |
| 300 | `--color-emerald-300` | `#5EE9B5FF` |
| 400 | `--color-emerald-400` | `#00D492FF` |
| 500 | `--color-emerald-500` | `#00BC7DFF` |
| 600 | `--color-emerald-600` | `#009966FF` |
| 700 | `--color-emerald-700` | `#007A55FF` |
| 800 | `--color-emerald-800` | `#006045FF` |
| 900 | `--color-emerald-900` | `#004F3BFF` |
| 950 | `--color-emerald-950` | `#002C22FF` |

### Teal
| Step | Variable | Hex |
|---|---|---|
| 50 | `--color-teal-50` | `#F0FDFAFF` |
| 100 | `--color-teal-100` | `#CBFBF1FF` |
| 200 | `--color-teal-200` | `#96F7E4FF` |
| 300 | `--color-teal-300` | `#46ECD5FF` |
| 400 | `--color-teal-400` | `#00D5BEFF` |
| 500 | `--color-teal-500` | `#00BBA7FF` |
| 600 | `--color-teal-600` | `#009689FF` |
| 700 | `--color-teal-700` | `#00786FFF` |
| 800 | `--color-teal-800` | `#005F5AFF` |
| 900 | `--color-teal-900` | `#0B4F4AFF` |
| 950 | `--color-teal-950` | `#022F2EFF` |

### Cyan
| Step | Variable | Hex |
|---|---|---|
| 50 | `--color-cyan-50` | `#ECFEFFFF` |
| 100 | `--color-cyan-100` | `#CEFAFEFF` |
| 200 | `--color-cyan-200` | `#A2F4FDFF` |
| 300 | `--color-cyan-300` | `#53EAFDFF` |
| 400 | `--color-cyan-400` | `#00D3F2FF` |
| 500 | `--color-cyan-500` | `#00B8DBFF` |
| 600 | `--color-cyan-600` | `#0092B8FF` |
| 700 | `--color-cyan-700` | `#007595FF` |
| 800 | `--color-cyan-800` | `#005F78FF` |
| 900 | `--color-cyan-900` | `#104E64FF` |
| 950 | `--color-cyan-950` | `#053345FF` |

### Sky
| Step | Variable | Hex |
|---|---|---|
| 50 | `--color-sky-50` | `#F0F9FFFF` |
| 100 | `--color-sky-100` | `#DFF2FEFF` |
| 200 | `--color-sky-200` | `#B8E6FEFF` |
| 300 | `--color-sky-300` | `#74D4FFFF` |
| 400 | `--color-sky-400` | `#00BCFFFF` |
| 500 | `--color-sky-500` | `#00A6F4FF` |
| 600 | `--color-sky-600` | `#0084D1FF` |
| 700 | `--color-sky-700` | `#0069A8FF` |
| 800 | `--color-sky-800` | `#00598AFF` |
| 900 | `--color-sky-900` | `#024A70FF` |
| 950 | `--color-sky-950` | `#052F4AFF` |

### Blue
| Step | Variable | Hex |
|---|---|---|
| 50 | `--color-blue-50` | `#EFF6FFFF` |
| 100 | `--color-blue-100` | `#DBEAFEFF` |
| 200 | `--color-blue-200` | `#BEDBFFFF` |
| 300 | `--color-blue-300` | `#8EC5FFFF` |
| 400 | `--color-blue-400` | `#51A2FFFF` |
| 500 | `--color-blue-500` | `#2B7FFFFF` |
| 600 | `--color-blue-600` | `#155DFCFF` |
| 700 | `--color-blue-700` | `#1447E6FF` |
| 800 | `--color-blue-800` | `#193CB8FF` |
| 900 | `--color-blue-900` | `#1C398EFF` |
| 950 | `--color-blue-950` | `#162456FF` |

### Indigo
| Step | Variable | Hex |
|---|---|---|
| 50 | `--color-indigo-50` | `#EEF2FFFF` |
| 100 | `--color-indigo-100` | `#E0E7FFFF` |
| 200 | `--color-indigo-200` | `#C6D2FFFF` |
| 300 | `--color-indigo-300` | `#A3B3FFFF` |
| 400 | `--color-indigo-400` | `#7C86FFFF` |
| 500 | `--color-indigo-500` | `#615FFFFF` |
| 600 | `--color-indigo-600` | `#4F39F6FF` |
| 700 | `--color-indigo-700` | `#432DD7FF` |
| 800 | `--color-indigo-800` | `#372AACFF` |
| 900 | `--color-indigo-900` | `#312C85FF` |
| 950 | `--color-indigo-950` | `#1E1A4DFF` |

### Violet
| Step | Variable | Hex |
|---|---|---|
| 50 | `--color-violet-50` | `#F5F3FFFF` |
| 100 | `--color-violet-100` | `#EDE9FEFF` |
| 200 | `--color-violet-200` | `#DDD6FFFF` |
| 300 | `--color-violet-300` | `#C4B4FFFF` |
| 400 | `--color-violet-400` | `#A684FFFF` |
| 500 | `--color-violet-500` | `#8E51FFFF` |
| 600 | `--color-violet-600` | `#7F22FEFF` |
| 700 | `--color-violet-700` | `#7008E7FF` |
| 800 | `--color-violet-800` | `#5D0EC0FF` |
| 900 | `--color-violet-900` | `#4D179AFF` |
| 950 | `--color-violet-950` | `#2F0D68FF` |

### Purple
| Step | Variable | Hex |
|---|---|---|
| 50 | `--color-purple-50` | `#FAF5FFFF` |
| 100 | `--color-purple-100` | `#F3E8FFFF` |
| 200 | `--color-purple-200` | `#E9D4FFFF` |
| 300 | `--color-purple-300` | `#DAB2FFFF` |
| 400 | `--color-purple-400` | `#C27AFFFF` |
| 500 | `--color-purple-500` | `#AD46FFFF` |
| 600 | `--color-purple-600` | `#9810FAFF` |
| 700 | `--color-purple-700` | `#8200DBFF` |
| 800 | `--color-purple-800` | `#6E11B0FF` |
| 900 | `--color-purple-900` | `#59168BFF` |
| 950 | `--color-purple-950` | `#3C0366FF` |

### Fuchsia
| Step | Variable | Hex |
|---|---|---|
| 50 | `--color-fuchsia-50` | `#FDF4FFFF` |
| 100 | `--color-fuchsia-100` | `#FAE8FFFF` |
| 200 | `--color-fuchsia-200` | `#F6CFFFFF` |
| 300 | `--color-fuchsia-300` | `#F4A8FFFF` |
| 400 | `--color-fuchsia-400` | `#ED6BFFFF` |
| 500 | `--color-fuchsia-500` | `#E12AFBFF` |
| 600 | `--color-fuchsia-600` | `#C800DEFF` |
| 700 | `--color-fuchsia-700` | `#A800B7FF` |
| 800 | `--color-fuchsia-800` | `#8A0194FF` |
| 900 | `--color-fuchsia-900` | `#721378FF` |
| 950 | `--color-fuchsia-950` | `#4B004FFF` |

### Pink
| Step | Variable | Hex |
|---|---|---|
| 50 | `--color-pink-50` | `#FDF2F8FF` |
| 100 | `--color-pink-100` | `#FCE7F3FF` |
| 200 | `--color-pink-200` | `#FCCEE8FF` |
| 300 | `--color-pink-300` | `#FDA5D5FF` |
| 400 | `--color-pink-400` | `#FB64B6FF` |
| 500 | `--color-pink-500` | `#F6339AFF` |
| 600 | `--color-pink-600` | `#E60076FF` |
| 700 | `--color-pink-700` | `#C6005CFF` |
| 800 | `--color-pink-800` | `#A3004CFF` |
| 900 | `--color-pink-900` | `#861043FF` |
| 950 | `--color-pink-950` | `#510424FF` |

### Rose
| Step | Variable | Hex |
|---|---|---|
| 50 | `--color-rose-50` | `#FFF1F2FF` |
| 100 | `--color-rose-100` | `#FFE4E6FF` |
| 200 | `--color-rose-200` | `#FFCCD3FF` |
| 300 | `--color-rose-300` | `#FFA1ADFF` |
| 400 | `--color-rose-400` | `#FF637EFF` |
| 500 | `--color-rose-500` | `#FF2056FF` |
| 600 | `--color-rose-600` | `#EC003FFF` |
| 700 | `--color-rose-700` | `#C70036FF` |
| 800 | `--color-rose-800` | `#A50036FF` |
| 900 | `--color-rose-900` | `#8B0836FF` |
| 950 | `--color-rose-950` | `#4D0218FF` |

## Radius

| Variable | Value |
|---|---|
| `--radius-None` | `0px` |
| `--radius-xs` | `2px` |
| `--radius-sm` | `4px` |
| `--radius-md` | `6px` |
| `--radius-lg` | `8px` |
| `--radius-xl` | `12px` |
| `--radius-2xl` | `16px` |
| `--radius-3xl` | `24px` |
| `--radius-4xl` | `32px` |
| `--radius-full` | `999px` |

## Border Width

| Variable | Value |
|---|---|
| `--border-width-0` | `0px` |
| `--border-width-1` | `1px` |
| `--border-width-2` | `2px` |
| `--border-width-4` | `4px` |
| `--border-width-8` | `8px` |

## Spacing

| Variable | Value |
|---|---|
| `--spacing-0` | `0px` |
| `--spacing-0.5` | `2px` |
| `--spacing-px` | `1px` |
| `--spacing-1` | `4px` |
| `--spacing-1-5` | `6px` |
| `--spacing-2` | `8px` |
| `--spacing-2-5` | `10px` |
| `--spacing-3` | `12px` |
| `--spacing-3-5` | `14px` |
| `--spacing-4` | `16px` |
| `--spacing-5` | `20px` |
| `--spacing-6` | `24px` |
| `--spacing-7` | `28px` |
| `--spacing-8` | `32px` |
| `--spacing-9` | `36px` |
| `--spacing-10` | `40px` |
| `--spacing-11` | `44px` |
| `--spacing-12` | `48px` |
| `--spacing-14` | `56px` |
| `--spacing-16` | `64px` |
| `--spacing-20` | `80px` |
| `--spacing-24` | `96px` |
| `--spacing-28` | `112px` |
| `--spacing-32` | `128px` |
| `--spacing-36` | `144px` |
| `--spacing-40` | `160px` |
| `--spacing-44` | `176px` |
| `--spacing-48` | `192px` |
| `--spacing-52` | `208px` |
| `--spacing-56` | `224px` |
| `--spacing-60` | `240px` |
| `--spacing-64` | `256px` |
| `--spacing-72` | `288px` |
| `--spacing-80` | `320px` |
| `--spacing-96` | `384px` |

## Opacity
 
| Variable | Value |
|---|---|
| `--opacity-0` | `0%` |
| `--opacity-5` | `5%` |
| `--opacity-10` | `10%` |
| `--opacity-15` | `15%` |
| `--opacity-20` | `20%` |
| `--opacity-25` | `25%` |
| `--opacity-30` | `30%` |
| `--opacity-35` | `35%` |
| `--opacity-40` | `40%` |
| `--opacity-45` | `45%` |
| `--opacity-50` | `50%` |
| `--opacity-55` | `55%` |
| `--opacity-60` | `60%` |
| `--opacity-65` | `65%` |
| `--opacity-70` | `70%` |
| `--opacity-75` | `75%` |
| `--opacity-80` | `80%` |
| `--opacity-85` | `85%` |
| `--opacity-90` | `90%` |
| `--opacity-95` | `95%` |
| `--opacity-100` | `100%` |

## Font Size

| Size | Value |
|---|---|
| `text-xs` | `12px` |
| `text-sm` | `14px` |
| `text-base` | `16px` |
| `text-lg` | `18px` |
| `text-xl` | `20px` |
| `text-2xl` | `24px` |
| `text-3xl` | `30px` |
| `text-4xl` | `36px` |
| `text-5xl` | `48px` |
| `text-6xl` | `60px` |
| `text-7xl` | `72px` |
| `text-8xl` | `96px` |
| `text-9xl` | `128px` |